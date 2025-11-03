import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/models/category.dart';
import 'package:mindle/models/complaint.dart';
import 'package:mindle/services/category_service.dart';
import 'package:mindle/services/svg_cache_service.dart';
import 'package:mindle/widgets/cached_complaint_marker.dart';
import 'package:dio/dio.dart' as dio;

class ComplaintListController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  final SvgCacheService _svgCacheService = SvgCacheService();

  Map<String, dynamic>? addressData;
  final RxList<Category> categories = <Category>[].obs;

  final selectedCityName = ''.obs; // 선택된 시/군 이름
  final selectedDistrictName = ''.obs; // 선택된 구/읍/면 이름
  final cityList = <String>[].obs; // 시/군 목록
  final districtList = <String>[].obs; // 구/읍/면 목록

  final Rxn<Category> selectedMainCategory = Rxn<Category>();
  final Rxn<Category> selectedSubCategory = Rxn<Category>();

  final RxString selectedCityCode = ''.obs;
  final RxString selectedDistrictCode = ''.obs;

  // 민원 목록 관련
  final RxList<Complaint> complaints = <Complaint>[].obs;
  final RxBool isLoadingComplaints = false.obs;
  final RxInt cursorComplaintId = 0.obs;
  final RxInt pageSize = 10.obs;
  final RxInt selectedCategoryId = 0.obs;
  final RxBool hasMoreComplaints = true.obs;

  // 선택된 지역 이름 저장
  final RxString selectedRegionText = '전체 지역'.obs;

  // 네이버 지도 컨트롤러
  late NaverMapController _mapController;
  // 네이버 지도 위치 오버레이
  late NLocationOverlay _locationOverlay;
  // 네이버 지도 준비 상태
  bool _isMapReady = false;

  // 마커 클릭 콜백
  Function(Complaint)? onMarkerTap;

  /// 클러스터 아이콘 캐시
  final Map<String, NOverlayImage> clusterIcons = {};

  // 현재 위치를 저장할 변수
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  // 위치 스트림을 저장할 변수
  Stream<Position> _positionStream = Stream.empty();
  // 위치 스트림 구독 저장할 변수
  late StreamSubscription<Position> _positionSubscription;

  final RxBool isLoadingLocations = false.obs;
  final RxList<NClusterableMarker> complaintMarkers =
      <NClusterableMarker>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadAddressData();
    _preloadSvgIcons();
  }

  /// SVG 아이콘들을 미리 로드해 캐싱
  Future<void> _preloadSvgIcons() async {
    try {
      await _svgCacheService.preloadSvgs([
        SvgPreloadConfig(
          assetPath: 'assets/icons/complaint-cold.svg',
          width: 70,
          height: 70,
        ),
        SvgPreloadConfig(
          assetPath: 'assets/icons/complaint-cold.svg',
          width: 70,
          height: 70,
          color: MindleColors.gray5,
        ),
        SvgPreloadConfig(
          assetPath: 'assets/icons/complaint-middle.svg',
          width: 70,
          height: 70,
        ),
        SvgPreloadConfig(
          assetPath: 'assets/icons/complaint-middle.svg',
          width: 70,
          height: 70,
          color: MindleColors.gray5,
        ),
        SvgPreloadConfig(
          assetPath: 'assets/icons/complaint-hot.svg',
          width: 70,
          height: 70,
        ),
        SvgPreloadConfig(
          assetPath: 'assets/icons/complaint-hot.svg',
          width: 70,
          height: 70,
          color: MindleColors.gray5,
        ),
      ]);
      print('SVG 아이콘 캐싱 완료');
    } catch (e) {
      print('SVG 아이콘 캐싱 실패: $e');
    }
  }

  Future<void> loadCategories() async {
    try {
      final loadedCategories = await _categoryService.getCategories();
      categories.value = loadedCategories;
      print('카테고리 불러오기 성공: ${categories.length}개');
    } catch (e) {
      Get.snackbar('오류', '카테고리를 불러오는데 실패했습니다');
      print(e);
    }
  }

  // JSON 파일에서 주소 데이터 로드
  Future<void> loadAddressData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/address_data.json',
      );
      addressData = json.decode(jsonString);

      // 경기도의 모든 하위 행정구역(시/군) 가져오기
      if (addressData != null && addressData!['경기도'] != null) {
        cityList.assignAll(addressData!['경기도'].keys.toList());
      }
    } catch (e) {
      print('주소 데이터 로드 실패: $e');
    }
  }

  void selectMainCategory(Category category) {
    selectedMainCategory.value = category;
    selectedSubCategory.value = null;
  }

  void selectSubCategory(Category category) {
    selectedSubCategory.value = category;
  }

  // 민원 목록 조회
  Future<void> loadComplaints({bool refresh = false}) async {
    if (isLoadingComplaints.value) return;

    if (refresh) {
      cursorComplaintId.value = 0;
      complaints.clear();
      hasMoreComplaints.value = true;
    }

    if (!hasMoreComplaints.value) return;

    isLoadingComplaints.value = true;

    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final dio.Dio dioClient = dio.Dio(
        dio.BaseOptions(
          baseUrl:
              "${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final queryParams = {
        'cursorComplaintId': cursorComplaintId.value,
        'pageSize': pageSize.value,
      };

      // 지역 코드 추가
      if (selectedCityCode.value.isNotEmpty) {
        queryParams['cityCode'] = int.parse(selectedCityCode.value);
      }
      if (selectedDistrictCode.value.isNotEmpty) {
        queryParams['districtCode'] = int.parse(selectedDistrictCode.value);
      }

      // 카테고리 ID 추가
      print('선택된 카테고리 ID: ${selectedCategoryId.value}');
      if (selectedCategoryId.value > 0) {
        queryParams['categoryId'] = selectedCategoryId.value;
      }

      final response = await dioClient.get(
        '/complaint/list',
        queryParameters: queryParams,
      );

      print('queryParams: $queryParams');
      print('민원 목록 응답: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Complaint> newComplaints = data
            .map((json) => Complaint.fromJson(json))
            .toList();

        if (refresh) {
          complaints.value = newComplaints;
        } else {
          complaints.addAll(newComplaints);
        }

        // 다음 페이지가 있는지 확인
        hasMoreComplaints.value = newComplaints.length == pageSize.value;

        // 커서 업데이트
        if (newComplaints.isNotEmpty) {
          cursorComplaintId.value = newComplaints.last.id;
        }

        print('민원 목록 조회 성공: ${newComplaints.length}개');
      } else {
        print('민원 목록 조회 실패: ${response.statusCode}');
        Get.snackbar('오류', '민원 목록을 불러오는데 실패했습니다');
      }
    } catch (e) {
      print('민원 목록 조회 중 오류: $e');
      Get.snackbar('오류', '민원 목록을 불러오는데 실패했습니다');
    } finally {
      isLoadingComplaints.value = false;
    }
  }

  // 필터 없이 민원 목록 조회 (위치 마커 로드용)
  Future<void> loadComplaintsWithoutFilter({bool refresh = false}) async {
    if (isLoadingComplaints.value) return;

    if (refresh) {
      cursorComplaintId.value = 0;
      complaints.clear();
      hasMoreComplaints.value = true;
    }

    if (!hasMoreComplaints.value) return;

    isLoadingComplaints.value = true;

    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final dio.Dio dioClient = dio.Dio(
        dio.BaseOptions(
          baseUrl:
              "${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final queryParams = {
        'cursorComplaintId': cursorComplaintId.value,
        'pageSize': pageSize.value,
      };

      final response = await dioClient.get(
        '/complaint/list',
        queryParameters: queryParams,
      );

      print('민원 목록 응답(필터 없음): ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Complaint> newComplaints = data
            .map((json) => Complaint.fromJson(json))
            .toList();

        if (refresh) {
          complaints.value = newComplaints;
        } else {
          complaints.addAll(newComplaints);
        }

        // 다음 페이지가 있는지 확인
        hasMoreComplaints.value = newComplaints.length == pageSize.value;

        // 커서 업데이트
        if (newComplaints.isNotEmpty) {
          cursorComplaintId.value = newComplaints.last.id;
        }

        print('민원 목록 조회 성공(필터 없음): ${newComplaints.length}개');
      } else {
        print('민원 목록 조회 실패(필터 없음): ${response.statusCode}');
        Get.snackbar('오류', '민원 목록을 불러오는데 실패했습니다');
      }
    } catch (e) {
      print('민원 목록 조회 중 오류(필터 없음): $e');
      Get.snackbar('오류', '민원 목록을 불러오는데 실패했습니다');
    } finally {
      isLoadingComplaints.value = false;
    }
  }

  // 시/군 선택
  void selectCity(String cityName) {
    selectedCityName.value = cityName;

    // 그 아래 행정구역(구/읍/면) 목록 업데이트
    if (addressData != null && addressData!['경기도'][cityName] != null) {
      final data = addressData!['경기도'][cityName];
      if (data is List) {
        // 2-depth가 없는 경우 (예: 가평군)
        districtList.clear();
      } else if (data is Map) {
        // 2-depth가 있는 경우 (예: 수원시)
        districtList.assignAll(
          List<String>.from(data.keys.map((key) => key.toString())),
        );
      }
    }
    // 구/읍/면 선택 초기화
    selectedDistrictName.value = '';
  }

  // 구/읍/면 선택
  void selectDistrict(String districtName) {
    selectedDistrictName.value = districtName;
  }

  // 현재 선택된 지역이 유효한지 확인
  bool isRegionSelectionValid() {
    if (selectedCityName.value.isEmpty) return false;

    // districtList가 비어있으면 city만 선택해도 OK
    if (districtList.isEmpty) return true;

    // districtList가 있으면 district도 선택해야 함
    return selectedDistrictName.value.isNotEmpty;
  }

  // 지역 이름으로 코드 조회
  Future<Map<String, String>?> _getRegionCodesByName({
    required String cityName,
    String? districtName,
  }) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final dio.Dio dioClient = dio.Dio(
        dio.BaseOptions(
          baseUrl:
              "${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final requestData = {'cityName': cityName};
      if (districtName != null && districtName.isNotEmpty) {
        requestData['districtName'] = districtName;
      }

      print('지역 코드 요청: $requestData');

      final response = await dioClient.post(
        '/region/by-name',
        data: requestData,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        print('지역 코드 응답: $data');

        Map<String, String> codes = {};

        // 시/군 코드 (첫 번째 district에서 cityCode 가져오기)
        if (data['region'] != null) {
          codes['cityCode'] = data['region']['cityCode'];
          codes['districtCode'] = data['region']['code'];
        }

        // 구/읍/면 코드는 필요시에만 추가 (현재는 사용하지 않음)

        return codes;
      }
    } catch (e) {
      print('지역 코드 조회 오류: $e');
    }
    return null;
  }

  // 지역 선택으로 필터 설정
  Future<void> setFilterByRegionSelection() async {
    if (!isRegionSelectionValid()) {
      Get.snackbar('알림', '지역을 올바르게 선택해주세요.');
      return;
    }

    print(
      '지역 선택: city=${selectedCityName.value}, district=${selectedDistrictName.value}',
    );

    final regionCodes = await _getRegionCodesByName(
      cityName: selectedCityName.value,
      districtName: selectedDistrictName.value.isNotEmpty
          ? selectedDistrictName.value
          : null,
    );

    if (regionCodes != null) {
      selectedCityCode.value = regionCodes['cityCode'] ?? '';
      selectedDistrictCode.value = regionCodes['districtCode'] ?? '';

      // 지역 텍스트 설정
      if (selectedDistrictName.value.isNotEmpty) {
        selectedRegionText.value =
            '${selectedCityName.value} > ${selectedDistrictName.value}';
      } else {
        selectedRegionText.value = selectedCityName.value;
      }

      print(
        '지역 코드 설정: city=${selectedCityCode.value}, district=${selectedDistrictCode.value}',
      );

      loadComplaints(refresh: true);
    } else {
      Get.snackbar('오류', '지역 코드를 찾을 수 없습니다.');
    }
  }

  // 필터 설정 (코드로 직접 설정)
  void setFilter({String? cityCode, String? districtCode, int? categoryId}) {
    bool shouldRefresh = false;

    if (cityCode != null && selectedCityCode.value != cityCode) {
      selectedCityCode.value = cityCode;
      shouldRefresh = true;
    }

    if (districtCode != null && selectedDistrictCode.value != districtCode) {
      selectedDistrictCode.value = districtCode;
      shouldRefresh = true;
    }

    if (categoryId != null && selectedCategoryId.value != categoryId) {
      selectedCategoryId.value = categoryId;
      shouldRefresh = true;
    }

    if (shouldRefresh) {
      loadComplaints(refresh: true);
    }
  }

  // 지역 필터 초기화
  void clearRegionFilter() {
    selectedCityCode.value = '';
    selectedDistrictCode.value = '';
    selectedCityName.value = '';
    selectedDistrictName.value = '';
    selectedRegionText.value = '전체 지역';
    districtList.clear();
    loadComplaints(refresh: true);
  }

  // 카테고리 필터 초기화
  void clearCategoryFilter() {
    selectedCategoryId.value = 0;
    loadComplaints(refresh: true);
  }

  // 전체 필터 초기화
  void clearAllFilters() {
    selectedCityCode.value = '';
    selectedDistrictCode.value = '';
    selectedCityName.value = '';
    selectedDistrictName.value = '';
    selectedCategoryId.value = 0;
    selectedRegionText.value = '전체 지역';
    districtList.clear();
    loadComplaints(refresh: true);
  }

  // 현재 선택된 지역 텍스트 반환
  String getSelectedRegionText() {
    return selectedRegionText.value;
  }

  String getSelectedCategoryText() {
    if (selectedCategoryId.value == 0) return '전체 카테고리';

    final category = categories.firstWhereOrNull(
      (cat) => cat.id == selectedCategoryId.value,
    );
    if (category != null) {
      return category.name;
    }

    // 서브 카테고리에서 찾기
    for (final mainCat in categories) {
      final subCat = mainCat.children.firstWhereOrNull(
        (sub) => sub.id == selectedCategoryId.value,
      );
      if (subCat != null) {
        return '${mainCat.name} > ${subCat.name}';
      }
    }

    return '선택된 카테고리';
  }

  // 네이버맵 컨트롤러를 받아와서 세팅하는 메소드
  void setMapController(NaverMapController controller) async {
    _mapController = controller;
    _locationOverlay = _mapController.getLocationOverlay();

    // 위치 오버레이 스타일 설정
    _locationOverlay.setCircleColor(MindleColors.mainGreen.withOpacity(0.3));
    _locationOverlay.setCircleRadius(65);
    _locationOverlay.setCircleOutlineColor(
      MindleColors.mainGreen.withOpacity(0.1),
    );
    _locationOverlay.setCircleOutlineWidth(50.0);

    _isMapReady = true;

    // 이거 없애면 위치 오버레이가 안 보임...
    _mapController.setLocationTrackingMode(NLocationTrackingMode.follow);

    print('네이버맵 컨트롤러가 설정되었습니다.');
    _startLocationStream();
  }

  // 권한 여부를 반환하는 메소드
  Future<bool> _handlePermission() async {
    // 기기의 위치 서비스가 활성화되어 있는지 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화되어 있으면, 사용자에게 위치 서비스를 활성화하도록 요청
      print("위치 서비스가 활성화되어 있지 않습니다.");
      return false;
    }

    // 위치 서비스가 활성화되어 있으면, 앱의 위치 권한을 확인
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("위치 권한이 거부된 상태입니다. 권한 요청 중...");
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        // 권한 요청이 성공적으로 완료되면 위치 접근 OK
        print("위치 권한이 허용되었습니다.");
        return true;
      }
      // 권한 요청이 거부되면 위치 접근 불가
      print("위치 권한이 거부되었습니다.");
      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      // 앱 설정 오픈 유도
      await Geolocator.openLocationSettings();
      print("위치 권한이 영구적으로 거부된 상태입니다. 앱 설정을 엽니다.");
      return false;
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // 위치 접근 OK
      print("위치 권한이 허용되었습니다.");
      return true;
    }
    return false;
  }

  // 위치 스트림을 시작하는 메소드
  Future<void> _startLocationStream() async {
    // 권한이 있는지 확인
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    // 일단 1회 위치 정보를 가져옴
    currentPosition.value = await Geolocator.getCurrentPosition();

    // 해당 위치로 카메라 이동
    moveCameraToCurrentPosition();

    // 민원들 위치 정보 로드하여 추가
    await loadAndAddComplaintMarkers();

    // 위치 스트림을 시작
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // 10미터 이상 이동 시 업데이트
        // distanceFilter: 10, // 테스트용: 이동 여부와 관계없이 일정 초마다 업데이트
      ),
    );

    // 위치 스트림을 구독하여 위치 업데이트를 처리
    _positionSubscription = _positionStream.listen((Position? position) {
      currentPosition.value = position;
      if (_isMapReady && position != null) {
        // print(
        //   '위치 업데이트: ${position.latitude.toString()}, ${position.longitude.toString()}',
        // );
        // 위치 오버레이를 업데이트
        _locationOverlay.setPosition(
          NLatLng(position.latitude, position.longitude),
        );
      }
    });
  }

  void moveCameraToCurrentPosition() {
    if (currentPosition.value != null) {
      _mapController.updateCamera(
        NCameraUpdate.withParams(
          target: NLatLng(
            currentPosition.value!.latitude,
            currentPosition.value!.longitude,
          ),
        ),
      );
    } else {
      print("현재 위치 정보가 없습니다.");
    }
  }

  // 민원 위치 정보 로드
  Future<void> loadAndAddComplaintMarkers() async {
    if (isLoadingLocations.value) return;

    isLoadingLocations.value = true;

    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final dio.Dio dioClient = dio.Dio(
        dio.BaseOptions(
          baseUrl:
              "${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List<NClusterableMarker> markers = [];

      // 현재 필터에 맞는 민원들 가져오기
      await loadComplaintsWithoutFilter(refresh: false);
      print('민원 위치 정보 로드: ${complaints.length}개 민원');
      for (final complaint in complaints) {
        // CachedComplaintMarker 위젯을 아이콘으로 사용 (즉시 렌더링)
        final marker = NClusterableMarker(
          id: 'complaint_${complaint.id}',
          position: NLatLng(complaint.latitude, complaint.longitude),
          icon: await NOverlayImage.fromWidget(
            widget: CachedComplaintMarker(key: UniqueKey(), complaintCount: 1),
            size: const Size(70, 70),
            context: Get.context!,
          ),
        );

        print('민원 마커 생성: 위치=(${complaint.latitude}, ${complaint.longitude})');

        // 마커 클릭 이벤트 설정
        marker.setOnTapListener((overlay) {
          print('마커 클릭됨: complaint_${complaint.id}');
          // 카메라 이동
          final latLng = NLatLng(complaint.latitude, complaint.longitude);
          _mapController.updateCamera(NCameraUpdate.withParams(target: latLng));

          // 바텀시트 콜백 호출
          if (onMarkerTap != null) {
            onMarkerTap!(complaint);
          }
        });

        markers.add(marker);
      }

      // 마커들을 지도에 추가
      if (markers.isNotEmpty) {
        await _mapController.addOverlayAll(markers.toSet());
        complaintMarkers.value = markers;
      }
    } catch (e) {
      print('민원 위치 정보 로드 중 오류: $e');
      Get.snackbar('오류', '민원 위치 정보를 불러오는데 실패했습니다');
    } finally {
      isLoadingLocations.value = false;
    }
  }

  /// 클러스터 마커 생성
  void buildClusterMarker(NClusterInfo info, NClusterMarker clusterMarker) {
    final key = 'cluster_${info.size}';

    // 이미 캐시에 있으면 바로 적용
    if (clusterIcons.containsKey(key)) {
      clusterMarker.setIcon(clusterIcons[key]);
      return;
    }

    // CachedComplaintMarker를 사용해 즉시 렌더링
    NOverlayImage.fromWidget(
      widget: CachedComplaintMarker(key: UniqueKey(), complaintCount: info.size),
      size: const Size(70, 70),
      context: Get.context!,
    ).then((icon) {
      clusterIcons[key] = icon;
      clusterMarker.setIcon(icon);
    });
  }

  @override
  void onClose() {
    // 위치 스트림 구독 취소
    _positionSubscription.cancel();
    super.onClose();
  }
}
