import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindle/models/category.dart';

class CategoryService {
  late final Dio _dio;

  CategoryService() {
    _dio = Dio(
      BaseOptions(
        baseUrl:
            "http://${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
  }

  Future<List<Category>> getCategories() async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final response = await _dio.get(
        '/category/all',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        print('응답 데이터 타입: ${response.data.runtimeType}');
        print('응답 데이터: ${response.data}');

        if (response.data is Map<String, dynamic>) {
          final Map<String, dynamic> responseMap = response.data;
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            final List<dynamic> data = responseMap['data'];
            return data.map((json) => Category.fromJson(json)).toList();
          } else {
            throw Exception('응답 형식이 올바르지 않습니다: $responseMap');
          }
        } else {
          throw Exception('예상하지 못한 응답 타입: ${response.data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('카테고리 로드 에러: $e');
      throw Exception('Failed to load categories: $e');
    }
  }
}
