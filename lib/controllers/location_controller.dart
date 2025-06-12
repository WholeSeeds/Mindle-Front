import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle;

class LocationController extends GetxController {
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final address = ''.obs;

  // 주소 데이터 관련 변수들
  final selectedCity = ''.obs; // 2-depth
  final selectedNbhd = ''.obs; // 3-depth
  final cities = <String>[].obs;
  final nbhds = <String>[].obs;
  Map<String, dynamic>? addressData;

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

      // 경기도의 모든 하위 행정구역(2-depth) 가져오기
      if (addressData != null && addressData!['경기도'] != null) {
        cities.value = addressData!['경기도'].keys.toList();
      }
    } catch (e) {
      print('주소 데이터 로드 실패: $e');
    }
  }

  // 2-depth 선택
  void selectCity(String city) {
    selectedCity.value = city;
    // 그 아래 행정구역(3-depth) 목록 업데이트
    if (addressData != null && addressData!['경기도'][city] != null) {
      nbhds.value = List<String>.from(addressData!['경기도'][city]);
    }
    selectedNbhd.value = ''; // 2-depth가 변경되면 3-depth 선택 초기화
  }

  // 3-depth 선택
  void selectNbhd(String nbhd) {
    selectedNbhd.value = nbhd;
    // 선택된 주소로 address 업데이트
    address.value = '경기도 ${selectedCity.value} ${selectedNbhd.value}';
  }

  // 현재 위치(위도, 경도) 가져오기
  Future getCurrentPosition() async {
    // 기기 위치 서비스 활성화 여부
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("기기 위치서비스 비활성화");
      return;
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

    // 현재 위치 구하기
    Position position = await Geolocator.getCurrentPosition();

    latitude.value = position.latitude;
    longitude.value = position.longitude;

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
          this.address.value =
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
}
