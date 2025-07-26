class User {
  final String id; // 사용자 고유 ID
  final String name; // 사용자 이름
  final String? nickname; // 닉네임 (있다면)
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    this.nickname,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'profileImage': profileImage,
    };
  }
}
