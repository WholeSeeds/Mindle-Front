import 'package:mindle/models/user.dart';

class Comment {
  final String id; // 댓글 고유 id
  final String content; // 댓글 내용
  final User author; // 댓글 작성자
  final DateTime createdAt; // 작성 시간
  final int numLikes; // 댓글 좋아요 수

  Comment({
    required this.id,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.numLikes,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      author: User.fromJson(json['author']),
      createdAt: DateTime.parse(json['createdAt']),
      numLikes: json['numLikes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'createdAt': createdAt,
      'numLikes': numLikes,
    };
  }
}
