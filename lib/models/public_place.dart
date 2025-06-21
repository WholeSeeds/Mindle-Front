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

  // factory 생성자에서 Google Places API의 사진 URL을 생성하는 메소드
  static String generatePlacePhotoUrl(String photoName) {
    final apiKey = dotenv.env['GOOGLE_MAPS_PLATFORM_API_KEY'];
    return 'https://places.googleapis.com/v1/$photoName/media?maxHeightPx=400&maxWidthPx=400&key=$apiKey';
  }

  factory PublicPlace.fromGoogleJson(Map<String, dynamic> json) {
    return PublicPlace(
      name: json['displayName']['text'] ?? '',
      uniqueId: json['placeId'] ?? '',
      type: List<String>.from(json['types']) ?? [],
      latitude: json['location']['latitude'] ?? 0.0,
      longitude: json['location']['longitude'] ?? 0.0,
      address: json['formattedAddress'] ?? '',
      photoUrl:
          (json['photos'] != null &&
              json['photos'] is List &&
              json['photos'].isNotEmpty)
          ? generatePlacePhotoUrl(json['photos'][0]['name'])
          : '',
    );
  }

  @override
  String toString() =>
      'PublicPlace(name: $name, uniqueId: $uniqueId, type: $type, latitude: $latitude, longitude: $longitude, address: $address, photoUrl: $photoUrl)';
}
