import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  var latitude = ''.obs;
  var longitude = ''.obs;

  // 현재위치 가져오기
  Future getCurrentPosition() async {
    // 기기 위치 서비스 활성화 여부
    bool serviceEndabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEndabled) {
      print("기기 위치서비스 비활성화");
      return null;
    }

    // 앱의 위치 접근 권한
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 권한 요청
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 거부
        print('위치 권한이 거부되었습니다.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 허용 안함
      print('위치 권한이 거부되었습니다.');
      return;
    }

    //현재 위치 구하기
    Position position = await Geolocator.getCurrentPosition();

    latitude.value = position.latitude.toString();
    longitude.value = position.longitude.toString();
  }
}
