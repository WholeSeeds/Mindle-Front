import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class TokenService extends GetxController {
  static TokenService get instance => Get.find<TokenService>();

  final Rx<String?> _accessToken = Rx<String?>(null);
  String? get accessToken => _accessToken.value;

  late final Dio _dio;

  TokenService() {
    _dio = Dio(
      BaseOptions(
        baseUrl:
            "http://${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
  }

  void setToken(String? token) {
    _accessToken.value = token;
    print(
      "🔐 TokenService - Token set: ${token != null ? 'YES (${token.substring(0, 30)}...)' : 'NULL'}",
    );
  }

  Future<String?> getCurrentUserToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final token = await user.getIdToken();
        setToken(token);
        return token;
      }
      return null;
    } catch (e) {
      print('토큰 가져오기 실패: $e');
      return null;
    }
  }

  Future<String?> refreshToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final token = await user.getIdToken(true);
        setToken(token);
        return token;
      }
      return null;
    } catch (e) {
      print('토큰 갱신 실패: $e');
      return null;
    }
  }

  void clearToken() {
    _accessToken.value = null;
  }

  Map<String, String> getAuthHeaders() {
    final token = accessToken;
    if (token != null) {
      return {'Authorization': 'Bearer $token'};
    }
    return {};
  }

  /// ✅ 서버 로그인 요청
  Future<Map<String, dynamic>?> loginWithToken(String? token) async {
    try {
      print("🚀 서버 로그인 요청 중...");

      final response = await _dio.get(
        '/member/login',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        print("✅ 서버 로그인 성공: ${response.data}");
        // 서버에서 추가 accessToken이나 user 데이터가 오면 여기서 처리
        if (response.data is Map<String, dynamic>) {
          final Map<String, dynamic> data = response.data;

          // 예: 서버에서 자체 토큰 발급 시
          if (data.containsKey('accessToken')) {
            setToken(data['accessToken']);
          }

          return data;
        } else {
          throw Exception('예상치 못한 응답 형식입니다: ${response.data.runtimeType}');
        }
      } else {
        print("❌ 서버 로그인 실패: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("🔥 로그인 중 예외 발생: $e");
      return null;
    }
  }
}
