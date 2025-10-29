import 'package:flutter_dotenv/flutter_dotenv.dart';

class PublicPlace {
  final String name;
  final String uniqueId;
  final List<String> type; // 예: 'local_government_office', 'police' 등
  final double latitude;
  final double longitude;
  final String address;
  final String photoUrl;

  PublicPlace({
    required this.name,
    required this.uniqueId,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.photoUrl,
  });

  factory PublicPlace.empty() {
    return PublicPlace(
      name: '',
      uniqueId: '',
      type: [],
      latitude: 0.0,
      longitude: 0.0,
      address: '',
      photoUrl: '',
    );
  }

  // factory 생성자에서 Google Places API의 사진 URL을 생성하는 메소드
  static String generatePlacePhotoUrl(String photoName) {
    final apiKey = dotenv.env['GOOGLE_MAPS_PLATFORM_API_KEY'];
    return 'https://places.googleapis.com/v1/$photoName/media?maxHeightPx=400&maxWidthPx=400&key=$apiKey';
  }

  factory PublicPlace.fromGoogleJson(Map<String, dynamic> json) {
    try {
      final name = json['displayName'] is Map<String, dynamic>
          ? json['displayName']['text'] ?? ''
          : '';

      final uniqueId = json['id'] ?? '';

      final types = json['types'] is List
          ? List<String>.from(json['types'])
          : <String>[];
      if (json['types'] is! List) {
        print('‼️경고: types 필드가 List가 아닙니다. 빈 리스트로 초기화되었습니다.');
      }

      final latitude = json['location']?['latitude'] ?? 0.0;
      final longitude = json['location']?['longitude'] ?? 0.0;

      final address = json['formattedAddress'] ?? '';

      final photoUrl =
          (json['photos'] != null &&
              json['photos'] is List &&
              json['photos'].isNotEmpty)
          ? generatePlacePhotoUrl(json['photos'][0]['name'])
          : '';
      return PublicPlace(
        name: name,
        uniqueId: uniqueId,
        type: types,
        latitude: latitude,
        longitude: longitude,
        address: address,
        photoUrl: photoUrl,
      );
    } catch (e) {
      print('PublicPlace.fromGoogleJson 파싱 실패: $e');
      return PublicPlace.empty();
    }
  }

  @override
  String toString() =>
      'PublicPlace(name: $name, uniqueId: $uniqueId, type: $type, latitude: $latitude, longitude: $longitude, address: $address, photoUrl: $photoUrl)';
}
