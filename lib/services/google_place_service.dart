import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mindle/models/public_place.dart';

// google place api로 주변 공공기관 검색
class GooglePlaceService extends GetxService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://places.googleapis.com/v1/',
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'X-Goog-Api-Key': dotenv.env['GOOGLE_MAPS_PLATFORM_API_KEY']!,
        'X-Goog-FieldMask':
            'places.displayName,places.id,places.types,places.location,places.formattedAddress,places.photos',
      },
    ),
  );

  Future<List<PublicPlace>> searchPlace(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _dio.post(
        'places:searchNearby',
        data: {
          "includedTypes": [
            "local_government_office",
            "police",
            "post_office",
            "city_hall",
            "courthouse",
          ],
          "maxResultCount": 3, // 최대 3개 결과로 제한
          "locationRestriction": {
            "circle": {
              "center": {"latitude": latitude, "longitude": longitude},
              "radius": 2000, // meters
            },
          },
          "languageCode": "ko",
        },
      );
      if (response.statusCode == 200) {
        final places = response.data['places'] as List;
        return places
            .map((place) => PublicPlace.fromGoogleJson(place))
            .toList();
        // photo url 확인용 코드
        // if (response.statusCode == 200) {
        //   final places = response.data['places'] as List;
        //   return places.map((place) {
        //     final publicPlace = PublicPlace.fromGoogleJson(place);
        //     print('📸 Photo URL: ${publicPlace.photoUrl}');
        //     return publicPlace;
        //   }).toList();
      } else {
        print('검색 실패: ${response.statusCode} ${response.statusMessage}');
        return [];
      }
    } catch (e) {
      print('주변 장소 검색 실패: $e');
      return [];
    }
  }
}
