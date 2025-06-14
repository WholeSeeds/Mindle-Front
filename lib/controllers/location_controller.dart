import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class LocationController extends GetxController {
  // 현재 주소 Rx string
  final currentAddress = ''.obs;

  // 주소 데이터 관련 변수들
  final selectedFirst = ''.obs; // 1-depth
  final selectedSecond = ''.obs; // 2-depth
  final selectedThird = ''.obs; // 2-depth
  final firstList = <String>[].obs;
  final secondList = <String>[].obs;
  final thirdList = <String>[].obs;
  Map<String, dynamic>? addressData;

  // 현재 위치를 저장할 변수
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  // 위치 스트림을 저장할 변수
  Stream<Position> _positionStream = Stream.empty();
  // 위치 스트림 구독 저장할 변수
  late StreamSubscription<Position> _positionSubscription;

  // Naver Map 관련 변수들----------
  // 네이버 지도 컨트롤러
  late NaverMapController _mapController;
  // 네이버 지도 위치 오버레이
  late NLocationOverlay _locationOverlay;
  // 네이버 지도 준비 상태
  bool _isMapReady = false;
  // ----------------------------

  @override
  void onInit() {
    super.onInit();
    loadAddressData();
  }

  // JSON 파일에서 주소 데이터 로드
  Future<void> loadAddressData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/address_data.json',
      );
      addressData = json.decode(jsonString);

      // 경기도의 모든 하위 행정구역(1-depth) 가져오기
      if (addressData != null && addressData!['경기도'] != null) {
        firstList.value = addressData!['경기도'].keys.toList();
      }
    } catch (e) {
      print('주소 데이터 로드 실패: $e');
    }
  }

  // 1-depth 선택
  void selectFirst(String first) {
    selectedFirst.value = first;

    // 그 아래 행정구역(2-depth) 목록 업데이트
    if (addressData != null && addressData!['경기도'][first] != null) {
      final data = addressData!['경기도'][first];
      if (data is List) {
        secondList.value = List<String>.from(data);
        thirdList.clear();
      } else if (data is Map) {
        secondList.value = List<String>.from(
          data.keys.map((key) => key.toString()),
        );
      }
    }
    // 2-depth, 3-depth 선택 초기화
    selectedSecond.value = '';
    selectedThird.value = '';
  }

  // 2-depth 선택
  void selectSecond(String second) {
    selectedSecond.value = second;

    final data = addressData!['경기도'][selectedFirst];
    // 3-depth가 존재하는 경우
    if (data is Map) {
      thirdList.value = List<String>.from(data[second]);
      selectedThird.value = ''; // 3-depth 선택 초기화
    }
    // else if (data is List) {
    //   // 선택된 주소로 currentAddress 업데이트
    //   currentAddress.value = '경기도 ${selectedFirst.value} ${selectedSecond.value}';
    // }
  }

  // 3-depth 선택
  void selectThird(String third) {
    selectedThird.value = third;

    // 선택된 주소로 currentAddress 업데이트
    // currentAddress.value = '경기도 ${selectedFirst.value} ${selectedSecond.value} $third';
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

  // 현재 위치(위도, 경도) 가져오기
  Future getCurrentPosition() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      print("위치 권한이 없거나 위치 서비스가 비활성화되어 있습니다.");
      return;
    }

    // 현재 위치 구하기
    Position position = await Geolocator.getCurrentPosition();

    // 현재 위치좌표로 주소 가져오기
    await getAddressFromLatLng(position.latitude, position.longitude);
  }

  // 현재 위치좌표로 주소 가져오기 (카카오 로컬 API 사용)
  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      final apiKey = dotenv.env['KAKAO_REST_API_KEY'];

      final response = await http.get(
        Uri.parse(
          'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$lng&y=$lat',
        ),
        headers: {'Authorization': 'KakaoAK $apiKey'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['documents'].isNotEmpty) {
          final address = data['documents'][0]['address'];
          currentAddress.value =
              '${address['region_1depth_name']} ${address['region_2depth_name']} ${address['region_3depth_name']}';
        }
      } else {
        print('주소 변환 실패: ${response.statusCode}');
        print('에러 내용: ${response.body}');
      }
    } catch (e) {
      print('주소를 가져오는데 실패했습니다: $e');
    }
  }


  // ---------네이버맵 관련 메소드들---------

  // 네이버맵 컨트롤러를 받아와서 세팅하는 메소드
  void setMapController(NaverMapController controller) async {
    _mapController = controller;
    _locationOverlay = _mapController.getLocationOverlay();
    _isMapReady = true;

    _mapController.setLocationTrackingMode(NLocationTrackingMode.follow);
    print('네이버맵 컨트롤러가 설정되었습니다.');
    _startLocationStream();
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

    // 위치 스트림을 시작
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        // distanceFilter: 10, // 10미터 이상 이동 시 업데이트
        distanceFilter: 0, // 테스트용: 이동 여부와 관계없이 일정 초마다 업데이트
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

  moveCameraToCurrentPosition() {
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

  @override
  void onClose() {
    // 위치 스트림 구독 취소
    _positionSubscription.cancel();
    super.onClose();
  }

  // -- 네이버맵 관련 메소드들 끝 -----------
}
