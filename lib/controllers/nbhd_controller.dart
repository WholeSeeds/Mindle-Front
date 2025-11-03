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
  final selectedThird = ''.obs; // 3-depth
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

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl:
            "${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
        connectTimeout: const Duration(seconds: 30),
      ),
    );
  }

  Future<void> loadAddressData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/address_data.json',
      );
      addressData = json.decode(jsonString);

      if (addressData != null && addressData!['경기도'] != null) {
        firstList.assignAll(addressData!['경기도'].keys.toList());
      }
    } catch (e) {
      print('주소 데이터 로드 실패: $e');
    }
  }

  void selectFirst(String first) {
    selectedFirst.value = first;

    final data = addressData!['경기도'][first];
    if (data is List) {
      secondList.assignAll(List<String>.from(data));
      thirdList.clear();
    } else if (data is Map) {
      secondList.assignAll(
        List<String>.from(data.keys.map((key) => key.toString())),
      );
    }

    selectedSecond.value = '';
    selectedThird.value = '';
  }

  void selectSecond(String second) {
    selectedSecond.value = second;

    final data = addressData!['경기도'][selectedFirst.value];
    if (data is Map && data[second] is List) {
      thirdList.assignAll(List<String>.from(data[second]));
    }
    selectedThird.value = '';
  }

  void selectThird(String third) {
    selectedThird.value = third;
  }

  /// 지역 정보 조회 (/region/by-name POST)
  Future<Map<String, dynamic>?> getRegionInfo() async {
    try {
      final requestData = {'cityName': selectedFirst.value};
      if (selectedSecond.value.isNotEmpty) {
        requestData['districtName'] = selectedSecond.value;
      } else {
        requestData['districtName'] = '';
      }
      if (selectedThird.value.isNotEmpty) {
        requestData['subdistrictName'] = selectedThird.value;
      }
      // final requestData = {
      //   'cityName': '의정부시',
      //   'districtName': '',
      //   'subdistrictName': '호원2동',
      // };
      print('📍 지역 정보 조회 요청: $requestData');

      final response = await _dio.post(
        '/region/by-name',
        data: requestData,
        options: Options(headers: _tokenService.getAuthHeaders()),
      );

      if (response.statusCode == 200) {
        final data = response.data['data']['region'];
        print('✅ 지역 정보 조회 성공: $data');
        return data;
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
    if (selectedFirst.value.isEmpty) {
      Get.snackbar('오류', '시/군을 선택해주세요.');
      return false;
    }

    try {
      final regionInfo = await getRegionInfo();
      if (regionInfo == null) return false;

      final subdistrictCode = regionInfo['code'];
      if (subdistrictCode == null) {
        Get.snackbar('오류', '동네 코드를 찾을 수 없습니다.');
        return false;
      }

      return await updateUserSubdistrict(subdistrictCode);
    } catch (e) {
      print('❌ 동네 설정 처리 오류: $e');
      Get.snackbar('오류', '동네 설정 중 오류가 발생했습니다.');
      return false;
    }
  }
}
