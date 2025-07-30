class Comment {
  final int id; // 댓글 고유 id
  final String content; // 댓글 내용
  final DateTime createdAt; // 작성 시간
  final int memberId; // 작성자 id
  final int numLikes; // 댓글 좋아요 수
  final String nickname; // 댓글 작성자 닉네임

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
