class Comment {
  final int id;
  final String content;
  final DateTime createdAt;
  final int numLikes;
  final String nickname;

  Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.numLikes,
    required this.nickname,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      numLikes: json['numLikes'] ?? 0,
      nickname: json['nickname'],
    );
  }
}
