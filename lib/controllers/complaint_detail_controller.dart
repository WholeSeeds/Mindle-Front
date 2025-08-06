import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mindle/models/comment.dart';
import 'package:mindle/models/complaint_detail.dart';
import 'package:mindle/models/reaction.dart';

class ComplaintDetailController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080/api',
      connectTimeout: const Duration(seconds: 30),
    ),
  );

  // 데이터 모델
  ComplaintDetail? complaintDetail;
  final Rx<Reaction?> reactionInfo = Rx<Reaction?>(null);

  // 댓글 관련
  final RxList<Comment> comments = <Comment>[].obs;
  final TextEditingController commentInputController = TextEditingController();
  bool isCommentInputFocused = false;

  // UI 상태
  int currentImageIndex = 0;
  final RxBool isLoading = false.obs;
  bool isComplaintResolvedCheckboxSelected = false;

  // 댓글 페이지네이션
  String? lastCursor;
  bool hasMoreComments = true;

  // 이미지 데이터 변수 추가
  List<Uint8List> imagesBytesList = [];

  // 알림 설정 상태
  final RxBool isNotificationEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // 민원 상세 정보
  Future<void> loadComplaintDetail(String complaintId) async {
    try {
      isLoading.value = true;
      imagesBytesList.clear(); // 기존 이미지 초기화

      final response = await _dio.get('/complaint/detail/$complaintId');

      if (response.statusCode == 200) {
        final data = response.data;
        complaintDetail = ComplaintDetail.fromJson(
          data['complaintDetailWithImagesDto'],
        );
        reactionInfo.value = Reaction.fromJson(data['reactionDto']);

        // 이미지 URL을 통해 직접 이미지 가져오기
        for (String url in complaintDetail?.imageUrls ?? []) {
          try {
            final imageResponse = await _dio.get<List<int>>(
              url,
              options: Options(responseType: ResponseType.bytes),
            );
            if (imageResponse.statusCode == 200) {
              imagesBytesList.add(Uint8List.fromList(imageResponse.data!));
            }
          } catch (e) {
            print('이미지 로딩 실패: $url');
          }
        }

        // 댓글 로딩
        await loadComments(complaintDetail!.id);
        update();
      } else {
        throw Exception("민원 상세 정보 로딩 실패");
      }
    } catch (e) {
      Get.snackbar('오류', '민원 정보를 불러오는데 실패했습니다.');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // 댓글 목록 조회
  Future<void> loadComments(int complaintId, {int pageSize = 10}) async {
    if (!hasMoreComments) return;

    try {
      final response = await _dio.get(
        '/complaint/comments',
        queryParameters: {
          'complaintId': complaintId,
          'cursorCreatedAt': lastCursor ?? '',
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> commentListJson = response.data['data'];
        final fetchedComments = commentListJson
            .map((json) => Comment.fromJson(json))
            .toList();

        if (fetchedComments.isNotEmpty) {
          lastCursor = fetchedComments.last.createdAt.toIso8601String();
          comments.addAll(fetchedComments);
        } else {
          hasMoreComments = false;
        }
        update();
      }
    } catch (e) {
      Get.snackbar('오류', '댓글을 불러오는 데 실패했습니다.');
    }
  }

  // 댓글 작성
  Future<void> addComment(String complaintId, String content) async {
    if (content.trim().isEmpty) return;

    try {
      await _dio.post(
        '/complaint/comment',
        data: {'complaintId': complaintId, 'content': content},
      );

      commentInputController.clear();
      setCommentInputFocus(false);

      // 댓글 목록 초기화 후 재 업로드
      comments.clear();
      lastCursor = null;
      hasMoreComments = true;
      await loadComments(int.parse(complaintId));
    } catch (e) {
      Get.snackbar('오류', '댓글 작성에 실패했습니다.');
    }
  }

  // 댓글 입력창 포커스 설정
  void setCommentInputFocus(bool focused) {
    isCommentInputFocused = focused;
    update();
  }

  // 이미지 슬라이더 이동
  void nextImage() {
    if (complaintDetail == null) return;
    if (currentImageIndex < complaintDetail!.imageUrls.length - 1) {
      currentImageIndex++;
      update();
    }
  }

  void prevImage() {
    if (currentImageIndex > 0) {
      currentImageIndex--;
      update();
    }
  }

  // 신고 기능
  Future<void> reportComplaint(String complaintId, String reason) async {
    // TODO: 신고 기능 API 개발 후 연동
  }

  // 알림 설정 토글
  Future<void> toggleNotification(String complaintId) async {
    // TODO: 알림 설정 API 개발 후 연동
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

  @override
  void onClose() {
    commentInputController.dispose();
    super.onClose();
  }
}
