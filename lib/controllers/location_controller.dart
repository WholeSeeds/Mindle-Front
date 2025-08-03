import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mindle/models/public_place.dart';
import 'package:mindle/models/region_info.dart';
import 'package:mindle/services/google_place_service.dart';
import 'package:mindle/services/naver_maps_service.dart';
import 'package:mindle/widgets/place_bottomsheet.dart';

class LocationController extends GetxController {
  // 현재 위치를 저장할 변수
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  // 위치 스트림을 저장할 변수
  Stream<Position> _positionStream = Stream.empty();
  // 위치 스트림 구독 저장할 변수
  late StreamSubscription<Position> _positionSubscription;

  // 위치 선택 모드 여부
  bool isSelectingLocation = false;
  // 선택된 위치 저장(해당 위치로 글 작성 위함)
  final Rx<PublicPlace?> selectedPlace = Rx<PublicPlace?>(null);
  final Rx<RegionInfo?> selectedRegionInfo = Rx<RegionInfo?>(null);
  // 선택된 위치 스트링(화면에 표시 위함)
  final RxString selectedLocationString = ''.obs;

  // 네이버 지도 컨트롤러
  late NaverMapController _mapController;
  // 네이버 지도 위치 오버레이
  late NLocationOverlay _locationOverlay;
  // 네이버 지도 준비 상태
  bool _isMapReady = false;

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

  // 네이버맵 컨트롤러를 받아와서 세팅하는 메소드
  void setMapController(NaverMapController controller) async {
    _mapController = controller;
    _locationOverlay = _mapController.getLocationOverlay();
    _isMapReady = true;

    // 이거 없애면 위치 오버레이가 안 보임...
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

    // 주변 공공기관 검색하여 지도에 마커 추가
    addMarker();

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

  // google place api 이용해 주변 공공기관을 검색하여 지도에 마커 추가
  Future<void> addMarker() async {
    final Set<NMarker> markers = {};

    final places = await Get.find<GooglePlaceService>().searchPlace(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
    );

    for (final place in places) {
      final markerId = 'marker_${place.latitude}_${place.longitude}';
      // print('마커 ID: $markerId, 이름: ${place.name}, 주소: ${place.address}');

      final marker = NClusterableMarker(
        id: markerId,
        position: NLatLng(place.latitude, place.longitude),
      );

      // 마커 탭했을 시
      marker.setOnTapListener((overlay) {
        if (isSelectingLocation) {
          // 위치 선택 모드일 때는 선택된 위치로 설정
          selectLocationToPlace(place);
        } else {
          // 위치 선택 모드가 아닐 때는 바텀 시트 열기
          final context = Get.context!;
          // 바텀 시트 열기
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            showDragHandle: true,
            builder: (_) {
              return PlaceBottomSheet(place: place);
            },
          );
        }
      });

      markers.add(marker);
    }

    // 마커 추가
    _mapController.addOverlayAll(markers);
    print('공공기관 마커가 추가되었습니다: ${places.length}개');
  }

  // 위치 선택: PublicPlace(공공기관)
  void selectLocationToPlace(PublicPlace place) {
    selectedPlace.value = place;
    selectedRegionInfo.value = null;

    final latLng = NLatLng(place.latitude, place.longitude);

    // 선택된 위치로 카메라 이동
    _mapController.updateCamera(NCameraUpdate.withParams(target: latLng));
  }

  // 위치 선택: RegionInfo(특정 좌표 -> 도로명주소)
  Future<void> selectLocationToLatLng(NLatLng latLng) async {
    selectedPlace.value = null;
    selectedRegionInfo.value = await Get.find<NaverMapsService>()
        .reverseGeoCode(latLng.latitude, latLng.longitude);

    // 선택된 위치로 카메라 이동
    _mapController.updateCamera(NCameraUpdate.withParams(target: latLng));
  }

  // 위치선택 해제
  void initSelectedLocation() {
    selectedPlace.value = null;
    selectedRegionInfo.value = null;
  }

  @override
  void onClose() {
    // 위치 스트림 구독 취소
    _positionSubscription.cancel();
    super.onClose();
  }
}
