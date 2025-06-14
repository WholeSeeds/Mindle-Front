import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class NbhdController extends GetxController {
  Map<String, dynamic>? addressData;

  final selectedFirst = ''.obs; // 1-depth
  final selectedSecond = ''.obs; // 2-depth
  final selectedThird = ''.obs; // 2-depth
  final firstList = <String>[].obs;
  final secondList = <String>[].obs;
  final thirdList = <String>[].obs;

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
}
