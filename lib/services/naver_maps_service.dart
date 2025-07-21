//  네이버맵 초기화는 현재 main에서 진행하고있음

// naver maps geocoding으로 좌표 -> 도로명주소로 변환
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mindle/models/region_info.dart';

class NaverMapsService extends GetxService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://maps.apigw.ntruss.com/map-reversegeocode/v2',
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'x-ncp-apigw-api-key-id': dotenv.env['NAVER_MAP_CLIENT_ID']!,
        'x-ncp-apigw-api-key': dotenv.env['NAVER_MAP_CLIENT_SECRET']!,
      },
    ),
  );

  Future<RegionInfo?> reverseGeoCode(double latitude, double longitude) async {
    final coordsStr = '$longitude,$latitude';
    try {
      final response = await _dio.get(
        '/gc',
        queryParameters: {
          'coords': coordsStr,
          'orders':
              'admcode,roadaddr', // 행정동 구역으로 변환 / 도로명 주소로 변환. 도로명 주소는 안 나올 수 있음
          'output': 'json',
        },
      );

      if (response.statusCode == 200) {
        final region = RegionInfo.fromNaverJson(response.data);
        return region;
      } else {
        print('도로명 주소 변환 실패: ${response.statusCode} ${response.statusMessage}');
        return null;
      }
    } catch (e) {
      print('도로명 주소 변환 실패: $e');
      return null;
    }
  }
}
