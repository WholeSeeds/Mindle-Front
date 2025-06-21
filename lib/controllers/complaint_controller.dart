import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindle/models/public_place.dart';

class ComplaintController extends GetxController {
  final categoryList = ['', '도로', '치안', '환경', '기타'];
  final selectedCategory = ''.obs;

  final title = ''.obs;
  final content = ''.obs;
  final RxList<XFile?> images = <XFile?>[].obs;
  final ImagePicker _picker = ImagePicker();

  // 이미지 추가: 카메라
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        if (images.length < 3) {
          images.add(pickedFile);
        }
      }
    } catch (e) {
      Get.snackbar('오류', '카메라에서 이미지 촬영 중 오류 발생');
    }
  }

  // 이미지 추가: 갤러리
  Future<void> pickImagesFromGallery() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        // 최대 3개까지만 추가
        if (images.length + pickedFiles.length > 3) {
          Get.snackbar('제한', '최대 3개의 이미지만 선택할 수 있습니다');
        }
        images.addAll(pickedFiles.take(3 - images.length));
      }
    } catch (e) {
      Get.snackbar('오류', '갤러리에서 이미지 선택 중 오류 발생');
    }
  }

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
    print('이미지: ${images.map((img) => img?.name).join(', ')}');
    print("______________________________________");
    Get.snackbar('성공!', '민원이 등록되었습니다');
    return;
  }
}
