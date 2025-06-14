import 'dart:async';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mindle/services/naver_local_search_service.dart';

class LocationController extends GetxController {
  // 현재 위치를 저장할 변수
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  // 위치 스트림을 저장할 변수
  Stream<Position> _positionStream = Stream.empty();
  // 위치 스트림 구독 저장할 변수
  late StreamSubscription<Position> _positionSubscription;

  // 네이버 지도 컨트롤러
  late NaverMapController _mapController;
  // 네이버 지도 위치 오버레이
  late NLocationOverlay _locationOverlay;
  // 네이버 지도 준비 상태
  bool _isMapReady = false;

  // 네이버맵 컨트롤러를 받아와서 세팅하는 메소드
  void setMapController(NaverMapController controller) async {
    _mapController = controller;
    _locationOverlay = _mapController.getLocationOverlay();
    _isMapReady = true;

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

    // 시청 마커 추가
    // 마커 확인 위한 임시 메소드, 나중에 api나 로직 변경 가능
    addCityHallMarker();

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

  // 시청 관련 기관을 검색하여 마커 추가
  Future<void> addCityHallMarker() async {
    // 네이버 지역 검색 서비스에서 '시청' 관련 기관 검색
    final institutions = await Get.find<NaverLocalSearchService>().searchPlace(
      '시청',
    );
    // for (final institution in institutions) {
    //   final marker = NMarker(
    //     id: 'marker_${institution.name}',
    //     position: NLatLng(institution.latitude, institution.longitude),
    //   );
    //
    //   final infoWindow = NInfoWindow.onMarker(
    //     id: 'info_${institution.name}',
    //     text: institution.name,
    //   );
    //
    //   // marker.setOnTapListener((_) {
    //   //   infoWindow.open(marker);
    //   // });
    //
    //   _mapController.addOverlay(marker);
    // }
  }

  @override
  void onClose() {
    // 위치 스트림 구독 취소
    _positionSubscription.cancel();
    super.onClose();
  }
}
