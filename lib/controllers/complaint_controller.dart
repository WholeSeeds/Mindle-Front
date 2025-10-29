import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindle/models/category.dart';
import 'package:mindle/models/public_place.dart';
import 'package:mindle/models/region_info.dart';
import 'package:mindle/services/category_service.dart';

class ComplaintController extends GetxController {
  final CategoryService _categoryService = CategoryService();

  final RxList<Category> categories = <Category>[].obs;
  final Rxn<Category> selectedMainCategory = Rxn<Category>();
  final Rxn<Category> selectedSubCategory = Rxn<Category>();

  final title = ''.obs;
  final content = ''.obs;
  final RxList<XFile?> images = <XFile?>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final loadedCategories = await _categoryService.getCategories();
      categories.value = loadedCategories;
      print('카테고리 불러오기 성공: ${categories.length}개');
    } catch (e) {
      Get.snackbar('오류', '카테고리를 불러오는데 실패했습니다');
      print(e);
    }
  }

  void selectMainCategory(Category category) {
    selectedMainCategory.value = category;
    selectedSubCategory.value = null;
  }

  void selectSubCategory(Category category) {
    selectedSubCategory.value = category;
  }

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

  // 민원 등록 서버에 요청 보내기
  // 둘 다 있음 / regionInfo만 있음 / 둘다 null
  void submitComplaint({PublicPlace? place, RegionInfo? regionInfo}) async {
    final categoryId =
        selectedSubCategory.value?.id ?? selectedMainCategory.value?.id;

    if (categoryId == null || title.value.isEmpty || content.value.isEmpty) {
      Get.snackbar('오류!', '모든 항목을 입력해주세요');
      return;
    }

    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    print('민원 등록 토큰: $token');
    final dio.Dio dioClient = dio.Dio(
      dio.BaseOptions(
        baseUrl:
            "http://${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final meta = {
      'categoryId': categoryId,
      'subDistrictCode': null,
      'title': title.value,
      'content': content.value,
    };

    print('민원 등록 place: $place, regionInfo: $regionInfo');

    if (regionInfo != null) {
      // place가 있으면 placeId와 위치 정보 추가
      if (place != null) {
        meta['placeId'] = place.uniqueId; // 예시: meta['placeId'] = 'uniqueid';
        meta['placeType'] = place.type[0]; // string으로 보내야함. 임시로 첫번째 요소 사용
        meta['placeName'] = place.name;
      }
      meta['latitude'] = regionInfo.latitude;
      meta['longitude'] = regionInfo.longitude;
      meta['subdistrictCode'] = regionInfo.subdistrictCode;
    }
    // 아무 정보도 없으면 정보를 추가하지 않음

    print('민원 등록 이미지 개수: ${images.length}');

    List<dio.MultipartFile> fileList = [];
    for (var image in images) {
      if (image != null) {
        final file = await dio.MultipartFile.fromFile(
          image.path,
          filename: image.name,
        );
        fileList.add(file);
      }
    }

    print('민원 등록 메타데이터: $meta');
    final formData = dio.FormData.fromMap({
      'meta': jsonEncode(meta),
      'files': fileList,
    });

    final response = await dioClient.post('/complaint/save', data: formData);

    print('민원 등록 응답 전체: ${response.statusCode} ${response.data}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('민원 등록 응답: ${response.statusCode} ${response.data}');
      Get.snackbar('성공!', '민원이 등록되었습니다');
    } else {
      print('민원 등록 실패: ${response.statusCode} ${response.data}');
      Get.snackbar('오류!', '민원 등록에 실패했습니다');
    }
  }
}
