class Place {
  final int id;
  final String placeId;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String typeName;
  final String subdistrictCode;

  Place({
    required this.id,
    required this.placeId,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.typeName,
    required this.subdistrictCode,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      placeId: json['placeId'],
      name: json['name'],
      description: json['description'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      typeName: json['typeName'] ?? '',
      subdistrictCode: json['subdistrictCode'] ?? '',
    );
  }

  factory Place.empty() {
    return Place(
      id: 0,
      placeId: '',
      name: '-',
      description: '',
      latitude: 0.0,
      longitude: 0.0,
      typeName: '',
      subdistrictCode: '',
    );
  }
}

class City {
  final String code;
  final String name;
  final String type;

  City({required this.code, required this.name, required this.type});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(code: json['code'], name: json['name'], type: json['type']);
  }

  factory City.empty() {
    return City(code: '', name: '-', type: '');
  }
}

class District {
  final String code;
  final String name;
  final String type;
  final String cityCode;

  District({
    required this.code,
    required this.name,
    required this.type,
    required this.cityCode,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      code: json['code'],
      name: json['name'],
      type: json['type'],
      cityCode: json['cityCode'],
    );
  }
  factory District.empty() {
    return District(code: '', name: '-', type: '', cityCode: '');
  }
}

class Subdistrict {
  final String code;
  final String name;
  final String type;

  Subdistrict({required this.code, required this.name, required this.type});

  factory Subdistrict.fromJson(Map<String, dynamic> json) {
    return Subdistrict(
      code: json['code'],
      name: json['name'],
      type: json['type'],
    );
  }

  factory Subdistrict.empty() {
    return Subdistrict(code: '', name: '-', type: '');
  }
}

class ComplaintDetail {
  final int id;
  final String title;
  final String content;
  final String categoryName;
  final String memberNickname;
  final Place place;
  final City city;
  final District district;
  final Subdistrict subdistrict;
  final DateTime createdAt;
  final List<String> imageUrls;

  String get placeName => place.name;
  String get cityName => city.name;
  String get districtName => district.name;
  String get subdistrictName => subdistrict.name;

  ComplaintDetail({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryName,
    required this.memberNickname,
    required this.place,
    required this.city,
    required this.district,
    required this.subdistrict,
    required this.createdAt,
    required this.imageUrls,
  });

  factory ComplaintDetail.fromJson(Map<String, dynamic> json) {
    return ComplaintDetail(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      categoryName: json['categoryName'],
      memberNickname: json['memberNickname'],
      place: json['place'] != null
          ? Place.fromJson(json['place'])
          : Place.empty(),
      city: json['city'] != null ? City.fromJson(json['city']) : City.empty(),
      district: json['district'] != null
          ? District.fromJson(json['district'])
          : District.empty(),
      subdistrict: json['subdistrict'] != null
          ? Subdistrict.fromJson(json['subdistrict'])
          : Subdistrict.empty(),
      createdAt: DateTime.parse(json['createdAt']),
      imageUrls: List<String>.from(json['imageUrlList'] ?? []),
    );
  }
}
