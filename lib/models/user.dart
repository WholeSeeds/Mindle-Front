class Subdistrict {
  final String code;
  final String name;
  final String type;

  Subdistrict({required this.code, required this.name, required this.type});

  factory Subdistrict.fromJson(Map<String, dynamic> json) {
    return Subdistrict(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class User {
  final int id;
  final String firebaseUid;
  final String? email;
  final String? phone;
  final String provider;
  final String nickname;
  final bool notificationPush;
  final bool notificationInapp;
  final int contributionScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Subdistrict? subdistrict;

  User({
    required this.id,
    required this.firebaseUid,
    required this.email,
    required this.phone,
    required this.provider,
    required this.nickname,
    required this.notificationPush,
    required this.notificationInapp,
    required this.contributionScore,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.subdistrict,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firebaseUid: json['firebaseUid'] ?? '',
      email: json['email'],
      phone: json['phone'],
      provider: json['provider'] ?? '',
      nickname: json['nickname'] ?? '',
      notificationPush: json['notificationPush'] ?? false,
      notificationInapp: json['notificationInapp'] ?? false,
      contributionScore: json['contributionScore'] ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      subdistrict: json['subdistrict'] != null 
          ? Subdistrict.fromJson(json['subdistrict'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebaseUid': firebaseUid,
      'email': email,
      'phone': phone,
      'provider': provider,
      'nickname': nickname,
      'notificationPush': notificationPush,
      'notificationInapp': notificationInapp,
      'contributionScore': contributionScore,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'subdistrict': {
        'code': subdistrict?.code,
        'name': subdistrict?.name,
        'type': subdistrict?.type,
      },
    };
  }
}
