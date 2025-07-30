import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/models/comment.dart';
import 'package:mindle/models/complaint.dart';
import 'package:mindle/models/public_place.dart';
import 'package:mindle/models/user.dart';

class ComplaintDetailController extends GetxController {
  // 민원 정보
  Complaint? complaint;
  User? author;
  String category = "";

  // 민원 장소 정보
  PublicPlace? place;

  // 민원 이미지들
  List<String> complaintImages = [];
  RxInt currentImageIndex = 0.obs; // 현재 보고 있는 이미지 인덱스

  // 해결 여부 관련
  RxBool isResolved = false.obs;
  RxString beforeImageUrl = "".obs;
  RxString afterImageUrl = "".obs;

  // 댓글 관련
  RxList<Comment> comments = <Comment>[].obs;
  final TextEditingController commentInputController = TextEditingController();
  RxBool isCommentInputFocused = false.obs;

  // 민원 해결 여부 확인
  RxBool isComplaintResolvedCheckboxSelected = false.obs;

  // 로딩 상태
  RxBool isLoading = false.obs;

  // Dio 인스턴스
  final Dio _dio = Dio();

  // API BASE URL
  static const String baseUrl = 'http://localhost:8080/api';

  @override
  void onInit() {
    super.onInit();
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  // 민원 상세 정보 로딩(댓글 포함)
  Future<void> loadComplaintDetail(String complaintId) async {
    try {
      isLoading.value = true;

      final response = await _dio.get('/complaint/detail/$complaintId');

      if (response.statusCode == 200) {
        final data = response.data;

        // 민원 기본 정보
        complaint = Complaint.fromJson(data['complaint']);

        // 작성자 정보
        author = User.fromJson(data['author']);

        // 카테고리
        category = data['category'] ?? "";

        // 위치 정보
        if (data['place'] != null) {
          place = PublicPlace.fromGoogleJson(data['place']);
        }

        complaintImages = List<String>.from(data['images'] ?? []);
        isResolved.value = complaint?.status == 'solved';
        beforeImageUrl = data['beforeImage'] ?? '';
        afterImageUrl = data['afterImage'] ?? '';

        comments.value = (data['comments'] as List)
            .map((commentJson) => Comment.fromJson(commentJson))
            .toList();

        update();

        // 민원 이미지들
        if (data['images'] != null) {
          complaintImages.value = List<String>.from(data['images']);
        }

        // 해결 여부 및 해결 사진들
        isResolved.value = complaint.value?.status == 'solved';
        beforeImageUrl.value = data['beforeImage'] ?? '';
        afterImageUrl.value = data['afterImage'] ?? '';

        // 댓글 목록
        if (data['comments'] != null) {
          comments.value = (data['comments'] as List)
              .map((commentJson) => Comment.fromJson(commentJson))
              .toList();
        }
      } else {
        throw Exception("민원 상세 정보 로딩 실패: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar('오류', '민원 정보를 불러오는데 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  // 이미지 슬라이더 이동
  void nextImage() {
    if (currentImageIndex < complaintImages.length - 1) {
      currentImageIndex.value++;
    }
  }

  void prevImage() {
    if (currentImageIndex > 0) {
      currentImageIndex.value--;
    }
  }

  // 댓글 작성
  Future<void> addComment(String complaintId, String content) async {
    if (content.trim().isEmpty) return;

    try {
      // TODO: 댓글 작성 API 개발 후 연동
      commentInputController.clear();
      isCommentInputFocused.value = false;

      // 새로고침
      await loadComplaintDetail(complaintId);
    } catch (e) {
      Get.snackbar('오류', '댓글 작성에 실패했습니다.');
    }
  }

  // 댓글 좋아요 토클
  Future<void> toggleCommentLike(String commentId) async {
    // TODO: 댓글 좋아요 API 개발 후 연동
  }

  // 민원 좋아요 토글
  Future<void> toggleComplaintLike(String complaintId) async {
    // TODO: 민원 좋아요 API 개발 후 연동
  }

  // 민원 해결 확인
  Future<void> markAsResolved(String complaintId) async {
    // TODO: 민원 해겷 확인 API 개발 후 연동
  }

  // 댓글 입려창 포커스 설정
  void setCommentInputFocus(bool focused) {
    isCommentInputFocused.value = focused;
  }

  @override
  void onClose() {
    commentInputController.dispose();
    super.onClose();
  }
}
