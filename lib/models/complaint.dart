import 'complaint_status.dart';

class Complaint {
  final int id;
  final String title;
  final String content;
  final int numLikes;
  final int numComments;
  final ComplaintStatus complaintStatus;
  final bool hasImage;
  final DateTime createdAt;
  final String? imageUrl;
  final bool resolved;
  final double latitude;
  final double longitude;

  Complaint({
    required this.id,
    required this.title,
    required this.content,
    required this.numLikes,
    required this.numComments,
    required this.complaintStatus,
    required this.hasImage,
    required this.createdAt,
    this.imageUrl,
    required this.resolved,
    required this.latitude,
    required this.longitude,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['complaintId'] ?? json['id'],
      title: json['title'],
      content: json['content'],
      numLikes: json['reactionCount'] ?? json['numLikes'] ?? 0,
      numComments: json['commentCount'] ?? json['numComments'] ?? 0,
      complaintStatus: json['resolved'] == true
          ? ComplaintStatus.solved
          : ComplaintStatus.waiting,
      hasImage:
          json['imageUrl'] != null && json['imageUrl'].toString().isNotEmpty,
      createdAt: DateTime.parse(json['createdAt']),
      imageUrl: json['imageUrl'],
      resolved: json['resolved'] ?? false,
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complaintId': id,
      'title': title,
      'content': content,
      'reactionCount': numLikes,
      'commentCount': numComments,
      'resolved': resolved,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
