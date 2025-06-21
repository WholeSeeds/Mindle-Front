class Complaint {
  final String title;
  final String content;
  final int numLikes;
  final int numComments;
  final String status; // 'no', 'solved', 'accepted'
  final bool hasImage;

  Complaint({
    required this.title,
    required this.content,
    required this.numLikes,
    required this.numComments,
    required this.status,
    required this.hasImage,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      title: json['title'],
      content: json['content'],
      numLikes: json['numLikes'],
      numComments: json['numComments'],
      status: json['status'],
      hasImage: json['hasImage'],
    );
  }
}
