class Report {
  final String title;
  final String content;
  final int numLikes;
  final int numComments;
  final String status; // 'no', 'solved', 'accepted'
  final bool hasImage;

  Report({
    required this.title,
    required this.content,
    required this.numLikes,
    required this.numComments,
    required this.status,
    required this.hasImage,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      title: json['title'],
      content: json['content'],
      numLikes: json['numLikes'],
      numComments: json['numComments'],
      status: json['status'],
      hasImage: json['hasImage'],
    );
  }
}
