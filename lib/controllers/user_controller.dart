import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mindle/models/user.dart';

class UserController extends GetxController {
  Dio? _dio;

  // 사용자 정보
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  /// _dio 초기화
  Future<void> _initDio() async {
    final token = await auth.FirebaseAuth.instance.currentUser?.getIdToken();

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

  /// 사용자 정보 불러오기
  Future<void> loadUserInfo() async {
    await _ensureDio();

    try {
      isLoading.value = true;
      final response = await _dio!.get('/member/my-info');
      print('response: ${response.data}');

      if (response.statusCode == 200) {
        currentUser.value = User.fromJson(response.data);
      } else {
        throw Exception("사용자 정보 로딩 실패");
      }
    } catch (e) {
      Get.snackbar('오류', '사용자 정보를 불러오는데 실패했습니다: $e');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// 사용자 정보 새로고침
  Future<void> refreshUserInfo() async {
    await loadUserInfo();
  }
}
