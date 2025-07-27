import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  void submitComplaint(PublicPlace place) async {
    if (selectedCategory.value.isEmpty ||
        title.value.isEmpty ||
        content.value.isEmpty) {
      Get.snackbar('오류!', '모든 항목을 입력해주세요');
      return;
    }

    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final dio.Dio _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl:
            "http://${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final meta = {
      // 'categoryId': 1, // 예시
      'categoryId': categoryList.indexOf(selectedCategory.value),
      'memberId': 1,
      'cityName': place.address,
      'districtName': null,
      'subDistrictName': null,
      // 'placeId': 'uniqueid', // 예시
      'placeId': place.uniqueId,
      'title': title.value,
      'content': content.value,
      'latitude': place.latitude,
      'longitude': place.longitude,
    };

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

    final formData = dio.FormData.fromMap({
      'meta': jsonEncode(meta),
      'files': fileList,
    });

    final response = await _dio.post('/complaint/save', data: formData);
    if (response.statusCode == 200) {
      print('민원 등록 응답: ${response.statusCode} ${response.data}');
      Get.snackbar('성공!', '민원이 등록되었습니다');
    } else {
      print('민원 등록 실패: ${response.statusCode} ${response.data}');
      Get.snackbar('오류!', '민원 등록에 실패했습니다');
    }
  }
}
