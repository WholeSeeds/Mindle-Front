class User {
  final int? level;
  final String? name;
  final String? profileImageUrl;
  final int? complaintCount;
  final int? solvedComplaintCount;

  User({
    this.level,
    this.name,
    this.profileImageUrl,
    this.complaintCount,
    this.solvedComplaintCount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      level: json['level'],
      name: json['name'],
      profileImageUrl: json['profileImageUrl'],
      complaintCount: json['complaintCount'],
      solvedComplaintCount: json['solvedComplaintCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'complaintCount': complaintCount,
      'solvedComplaintCount': solvedComplaintCount,
    };
  }
}
