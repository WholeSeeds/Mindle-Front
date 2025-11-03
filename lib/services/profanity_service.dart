import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfanityHit {
  final String profanity;
  final int index;

  ProfanityHit({required this.profanity, required this.index});

  factory ProfanityHit.fromJson(Map<String, dynamic> json) {
    return ProfanityHit(profanity: json['profanity'], index: json['index']);
  }
}

class ProfanityCheckResult {
  final bool passed;
  final List<ProfanityHit> hits;

  ProfanityCheckResult({required this.passed, required this.hits});

  factory ProfanityCheckResult.fromJson(Map<String, dynamic> json) {
    return ProfanityCheckResult(
      passed: json['passed'],
      hits:
          (json['hits'] as List<dynamic>?)
              ?.map((hit) => ProfanityHit.fromJson(hit))
              .toList() ??
          [],
    );
  }
}

class ProfanityService {
  late final Dio _dio;

  ProfanityService() {
    _dio = Dio(
      BaseOptions(
        baseUrl:
            "${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
  }

  Future<ProfanityCheckResult> checkProfanity(String text) async {
    print('비속어 검사 요청 텍스트: $text');
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final response = await _dio.post(
        '/moderation/profanity/check',
        data: {'text': text},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('비속어 검사 응답: ${response.data}');

      if (response.statusCode == 200) {
        final checkResult = ProfanityCheckResult.fromJson(
          response.data['data'],
        );
        return checkResult;
      } else {
        throw Exception('Failed to check profanity: ${response.statusCode}');
      }
    } catch (e) {
      print('비속어 검사 에러: $e');
      throw Exception('Failed to check profanity: $e');
    }
  }
}
