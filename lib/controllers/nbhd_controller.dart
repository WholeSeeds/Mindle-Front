import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindle/services/token_service.dart';
import 'package:mindle/controllers/user_controller.dart';

class NbhdController extends GetxController {
  Map<String, dynamic>? addressData;
  late final Dio _dio;
  late final TokenService _tokenService;

  final selectedFirst = ''.obs; // 1-depth
  final selectedSecond = ''.obs; // 2-depth
  final selectedThird = ''.obs; // 2-depth
  final firstList = <String>[].obs;
  final secondList = <String>[].obs;
  final thirdList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _tokenService = Get.find<TokenService>();
    _initDio();
    loadAddressData();
  }

  /// Dio 초기화
  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl:
            "http://${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
        connectTimeout: const Duration(seconds: 30),
      ),
    );
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
        firstList.assignAll(addressData!['경기도'].keys.toList());
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
        secondList.assignAll(List<String>.from(data));
        thirdList.clear();
      } else if (data is Map) {
        secondList.assignAll(
          List<String>.from(data.keys.map((key) => key.toString())),
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
      thirdList.assignAll(List<String>.from(data[second]));
      selectedThird.value = ''; // 3-depth 선택 초기화
    }
  }

  // 3-depth 선택
  void selectThird(String third) {
    selectedThird.value = third;
  }

  /// 지역 정보 조회 (/region/by-name POST)
  Future<Map<String, dynamic>?> getRegionInfo() async {
    try {
      // 요청 데이터 구성
      Map<String, String> requestData = {
        'cityName': selectedFirst.value,
      };

      if (selectedSecond.value.isNotEmpty) {
        requestData['districtName'] = selectedSecond.value;
      }

      if (selectedThird.value.isNotEmpty) {
        requestData['subdistrictName'] = selectedThird.value;
      }

      print('📍 지역 정보 조회 요청: $requestData');

      final response = await _dio.post(
        '/region/by-name',
        data: requestData,
        options: Options(headers: _tokenService.getAuthHeaders()),
      );

      if (response.statusCode == 200) {
        print('✅ 지역 정보 조회 성공: ${response.data}');
        return response.data;
      } else {
        throw Exception('지역 정보 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 지역 정보 조회 오류: $e');
      Get.snackbar('오류', '지역 정보를 조회하는데 실패했습니다.');
      return null;
    }
  }

  /// 사용자 동네 설정 업데이트 (/member/subdistrict PATCH)
  Future<bool> updateUserSubdistrict(String subdistrictCode) async {
    try {
      print('🏠 동네 설정 업데이트 요청: $subdistrictCode');

      final response = await _dio.patch(
        '/member/subdistrict',
        data: {'subdistrictCode': subdistrictCode},
        options: Options(headers: _tokenService.getAuthHeaders()),
      );

      if (response.statusCode == 200) {
        print('✅ 동네 설정 업데이트 성공: ${response.data}');
        
        // UserController의 사용자 정보 갱신
        try {
          final userController = Get.find<UserController>();
          await userController.refreshUserInfo();
        } catch (e) {
          print('UserController 갱신 실패: $e');
        }

        Get.snackbar('성공', '동네 설정이 완료되었습니다.');
        return true;
      } else {
        throw Exception('동네 설정 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 동네 설정 오류: $e');
      Get.snackbar('오류', '동네 설정에 실패했습니다.');
      return false;
    }
  }

  /// 선택된 주소로 동네 설정 완료
  Future<bool> setNeighborhood() async {
    if (selectedFirst.isEmpty) {
      Get.snackbar('오류', '시/군을 선택해주세요.');
      return false;
    }

    try {
      // 1. 지역 정보 조회
      final regionInfo = await getRegionInfo();
      if (regionInfo == null) return false;

      // 2. subdistricts에서 선택된 동네의 코드 찾기
      final subdistricts = regionInfo['subdistricts'] as List?;
      if (subdistricts == null || subdistricts.isEmpty) {
        Get.snackbar('오류', '선택하신 지역의 동네 정보를 찾을 수 없습니다.');
        return false;
      }

      String? subdistrictCode;
      
      // 3-depth가 선택된 경우 해당 동네 찾기
      if (selectedThird.isNotEmpty) {
        for (final subdistrict in subdistricts) {
          if (subdistrict['name'] == selectedThird.value) {
            subdistrictCode = subdistrict['code'];
            break;
          }
        }
      } else {
        // 3-depth가 없으면 첫 번째 subdistrict 사용
        subdistrictCode = subdistricts.first['code'];
      }

      if (subdistrictCode == null) {
        Get.snackbar('오류', '동네 코드를 찾을 수 없습니다.');
        return false;
      }

      // 3. 사용자 동네 설정 업데이트
      return await updateUserSubdistrict(subdistrictCode);
    } catch (e) {
      print('❌ 동네 설정 처리 오류: $e');
      Get.snackbar('오류', '동네 설정 중 오류가 발생했습니다.');
      return false;
    }
  }
}
