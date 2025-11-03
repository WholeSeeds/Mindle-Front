import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mindle/models/user.dart';
import 'package:mindle/controllers/auth_controller.dart';
import 'package:mindle/services/token_service.dart';

class UserController extends GetxController {
  late final Dio _dio;
  late final AuthController _authController;
  late final TokenService _tokenService;

  // 사용자 정보
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  final int myComplaintCount = 5;
  final int myComplaintSolvedCount = 3;
  final int myLikesCount = 14;
  final int myCommentsCount = 9;

  @override
  void onInit() {
    super.onInit();
    _authController = Get.find<AuthController>();
    _tokenService = Get.find<TokenService>();
    _initDio();

    // AuthController의 사용자 상태 변화를 감지
    ever(_authController.user, (auth.User? user) {
      if (user != null) {
        loadUserInfo();
      } else {
        currentUser.value = null;
      }
    });

    // 초기 로드
    if (_authController.user.value != null) {
      loadUserInfo();
    }
  }

  /// _dio 초기화
  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl:
            "${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
        connectTimeout: const Duration(seconds: 30),
      ),
    );
  }

  /// 사용자 정보 불러오기
  Future<void> loadUserInfo() async {
    // Firebase 사용자가 로그인되어 있는지 확인
    if (_authController.user.value == null) {
      print('❌ Firebase 사용자가 로그인되어 있지 않습니다.');
      currentUser.value = null;
      return;
    }

    try {
      isLoading.value = true;

      // TokenService에서 인증 헤더 가져오기
      final authHeaders = _tokenService.getAuthHeaders();
      if (authHeaders.isEmpty) {
        print('❌ 인증 토큰이 없습니다.');
        await _tokenService.getCurrentUserToken(); // 토큰 갱신 시도
      }

      final response = await _dio.get(
        '/member/my-info',
        options: Options(headers: _tokenService.getAuthHeaders()),
      );

      print('✅ 사용자 정보 로드 성공: ${response.data}');

      if (response.statusCode == 200) {
        currentUser.value = User.fromJson(response.data['data']);
      } else {
        throw Exception("사용자 정보 로딩 실패: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ 사용자 정보 로드 실패: $e');

      // 401 에러인 경우 토큰 갱신 시도
      if (e is DioException && e.response?.statusCode == 401) {
        try {
          await _tokenService.refreshToken();
          // 토큰 갱신 후 재시도
          final retryResponse = await _dio.get(
            '/member/my-info',
            options: Options(headers: _tokenService.getAuthHeaders()),
          );

          if (retryResponse.statusCode == 200) {
            currentUser.value = User.fromJson(retryResponse.data);
            return;
          }
        } catch (retryError) {
          print('❌ 토큰 갱신 후 재시도 실패: $retryError');
        }
      }

      Get.snackbar('오류', '사용자 정보를 불러오는데 실패했습니다');
    } finally {
      isLoading.value = false;
    }
  }

  /// 사용자 정보 새로고침
  Future<void> refreshUserInfo() async {
    await loadUserInfo();
  }
}
