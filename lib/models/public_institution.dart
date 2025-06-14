class PublicInstitution {
  final String name;
  final double latitude;
  final double longitude;

  PublicInstitution({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory PublicInstitution.fromJson(Map<String, dynamic> json) {
    return PublicInstitution(
      name: json['title'].replaceAll(RegExp(r'<[^>]*>'), ''), // HTML 태그 제거
      latitude: double.parse(json['mapy']),
      longitude: double.parse(json['mapx']),
    );
  }

  factory PublicInstitution.fromConvertedJson(Map<String, dynamic> json) {
    return PublicInstitution(
      name: json['title'].replaceAll(RegExp(r'<[^>]*>'), ''), // HTML 태그 제거
      latitude: double.parse(json['mapy']) / 1e7,
      longitude: double.parse(json['mapx']) / 1e7,
    );
  }

  @override
  String toString() =>
      'PublicInstitution(name: $name, lat: $latitude, lng: $longitude)';
}
