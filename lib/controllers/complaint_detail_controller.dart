import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindle/models/comment.dart';
import 'package:mindle/models/complaint_detail.dart';
import 'package:mindle/models/reaction.dart';

class ComplaintDetailController extends GetxController {
  Dio? _dio; // nullable로 선언

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

  // 이미지 데이터 변수
  List<Uint8List> imagesBytesList = [];

  // 알림 설정 상태
  final RxBool isNotificationEnabled = false.obs;

  // 해결된 민원 상세 정보 펼치기/접기 상태
  bool isExpanded = false;

  @override
  void onInit() {
    super.onInit();
  }

  /// _dio 초기화
  Future<void> _initDio() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();

    _dio = Dio(
      BaseOptions(
        baseUrl:
            "http://${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
        headers: {'Authorization': 'Bearer $token'},
        connectTimeout: const Duration(seconds: 30),
      ),
    );
  }

  /// _dio가 초기화되었는지 확인하고, 초기화되지 않았다면 초기화
  Future<void> _ensureDio() async {
    if (_dio == null) {
      await _initDio();
    }
  }

  /// 민원 상세 정보 불러오기
  Future<void> loadComplaintDetail(String complaintId) async {
    await _ensureDio();
    print(
      "Base URL: http://${dotenv.env['SERVER_HOST']}:${dotenv.env['SERVER_PORT']}/api",
    );

    try {
      isLoading.value = true;
      imagesBytesList.clear();

      final response = await _dio!.get('/complaint/detail/$complaintId');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        print('민원 상세 정보 응답 데이터: $data');
        complaintDetail = ComplaintDetail.fromJson(
          data['complaintDetailWithImagesDto'],
        );
        reactionInfo.value = data['reactionDto'] != null
            ? Reaction.fromJson(data['reactionDto'])
            : null;

        // 이미지 불러오기
        for (String url in complaintDetail?.imageUrls ?? []) {
          try {
            final imageResponse = await _dio!.get<List<int>>(
              url,
              options: Options(responseType: ResponseType.bytes),
            );
            if (imageResponse.statusCode == 200) {
              imagesBytesList.add(Uint8List.fromList(imageResponse.data!));
            }
          } catch (_) {
            print('이미지 로딩 실패: $url');
          }
        }

        await loadComments(complaintDetail!.id);
        update();
      } else {
        throw Exception("민원 상세 정보 로딩 실패");
      }
    } catch (e) {
      Get.snackbar('오류', '민원 정보를 불러오는데 실패했습니다: $e');
      print(e);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// 댓글 목록 조회
  Future<void> loadComments(int complaintId, {int pageSize = 10}) async {
    await _ensureDio();
    if (!hasMoreComments) return;

    try {
      final response = await _dio!.get(
        '/complaint/detail/comment',
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
      Get.snackbar('오류', '댓글을 불러오는 데 실패했습니다. $e');
      print(e);
    }
  }

  /// 댓글 작성
  Future<void> addComment(String complaintId, String content) async {
    if (content.trim().isEmpty) return;
    await _ensureDio();

    try {
      await _dio!.post(
        '/complaint/comment',
        data: {'complaintId': complaintId, 'content': content},
      );

      commentInputController.clear();
      setCommentInputFocus(false);

      // 댓글 목록 초기화 후 재업로드
      comments.clear();
      lastCursor = null;
      hasMoreComments = true;
      await loadComments(int.parse(complaintId));
    } catch (e) {
      Get.snackbar('오류', '댓글 작성에 실패했습니다.');
    }
  }

  /// 댓글 입력창 포커스 설정
  void setCommentInputFocus(bool focused) {
    isCommentInputFocused = focused;
    update();
  }

  /// 이미지 슬라이더 이동
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

  /// 신고 기능
  Future<void> reportComplaint(String complaintId, String reason) async {
    // TODO: 신고 기능 API 개발 후 연동
  }

  /// 알림 설정 토글
  Future<void> toggleNotification(String complaintId) async {
    // TODO: 알림 설정 API 개발 후 연동
  }

  /// 댓글 좋아요 토글
  Future<void> toggleCommentLike(String commentId) async {
    // TODO: 댓글 좋아요 API 개발 후 연동
  }

  /// 민원 좋아요 토글
  Future<void> toggleComplaintLike(String complaintId) async {
    // TODO: 민원 좋아요 API 개발 후 연동
  }

  /// 민원 해결 확인
  Future<void> markAsResolved(String complaintId) async {
    // TODO: 민원 해결 확인 API 개발 후 연동
  }

  /// 민원 상세 정보 펼치기/접기 토글
  void toggleExpanded() {
    isExpanded = !isExpanded;
    update();
  }

  @override
  void onClose() {
    commentInputController.dispose();
    super.onClose();
  }
}
