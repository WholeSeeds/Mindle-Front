import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mindle/models/public_institution.dart';

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

  Future<List<PublicInstitution>> searchPlace(
    double latitude,
    double longitude,
  ) async {
    print('api key: ${dotenv.env['GOOGLE_MAPS_PLATFORM_API_KEY']}');
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
          "maxResultCount": 20,
          "locationRestriction": {
            "circle": {
              "center": {"latitude": latitude, "longitude": longitude},
              "radius": 2000, // meters
            },
          },
        },
      );
      if (response.statusCode == 200) {
        final places = response.data['places'] as List;
        print(places);
        return places
            .map((place) => PublicInstitution.fromGoogleJson(place))
            .toList();
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
