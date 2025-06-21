import 'package:get/get.dart';
import 'package:mindle/models/public_place.dart';

class ComplaintController extends GetxController {
  final categoryList = ['', '도로', '치안', '환경', '기타'];
  final selectedCategory = ''.obs;

  final title = ''.obs;
  final content = ''.obs;

  void submitComplaint(PublicPlace place) {
    if (selectedCategory.value.isEmpty ||
        title.value.isEmpty ||
        content.value.isEmpty) {
      Get.snackbar('오류!', '모든 항목을 입력해주세요');
      return;
    }

    // 등록 요청로직 추가하기
    print('_____________민원 등록 요청______________');
    print('카테고리: ${selectedCategory.value}');
    print('제목: ${title.value}');
    print('내용: ${content.value}');
    print("______________________________________");
    Get.snackbar('성공!', '민원이 등록되었습니다');
    return;
  }
}
