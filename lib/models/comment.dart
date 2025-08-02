class Comment {
  final int id;
  final String content;
  final DateTime createdAt;
  final int memberId;
  final int numLikes;
  final String nickname;

  Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.memberId,
    required this.numLikes,
    required this.nickname,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      memberId: json['memberId'],
      numLikes: json['numLikes'] ?? 0,
      nickname: json['nickname'],
    );
  }
}
