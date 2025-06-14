import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mindle/models/public_institution.dart';

// 네이버 지역 검색 api로 특정 쿼리 검색
class NaverLocalSearchService extends GetxService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://openapi.naver.com/v1/search/',
      headers: {
        'X-Naver-Client-Id': dotenv.env['NAVER_SEARCH_CLIENT_ID'],
        'X-Naver-Client-Secret': dotenv.env['NAVER_SEARCH_CLIENT_SECRET'],
      },
    ),
  );

  Future<List<PublicInstitution>> searchPlace(String query) async {
    try {
      final response = await _dio.get(
        'local.json',
        queryParameters: {'query': query, 'display': 5, 'start': 1},
      );
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        print('검색 결과: $items');
        return items.map((item) => PublicInstitution.fromJson(item)).toList();
      } else {
        print('검색 실패: ${response.statusCode} ${response.statusMessage}');
        return [];
      }
    } catch (e) {
      print('지역 검색 실패: $e');
      return [];
    }
  }
}
