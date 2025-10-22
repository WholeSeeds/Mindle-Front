import 'complaint_status.dart';

class Complaint {
  final int id;
  final String title;
  final String content;
  final int numLikes;
  final int numComments;
  final ComplaintStatus complaintStatus;
  final bool hasImage;

  Complaint({
    required this.id,
    required this.title,
    required this.content,
    required this.numLikes,
    required this.numComments,
    required this.complaintStatus,
    required this.hasImage,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      numLikes: json['numLikes'],
      numComments: json['numComments'],
      complaintStatus: ComplaintStatus.fromJson(json['complaintStatus'] ?? json['status']),
      hasImage: json['hasImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'numLikes': numLikes,
      'numComments': numComments,
      'complaintStatus': complaintStatus.toJson(),
      'hasImage': hasImage,
    };
  }
}
