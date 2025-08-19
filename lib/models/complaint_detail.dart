class ComplaintDetail {
  final int id;
  final String title;
  final String content;
  final String categoryName;
  final String memberNickname;
  final String placeName;
  final String cityName;
  final String districtName;
  final String subdistrictName;
  final DateTime createdAt;
  final List<String> imageUrls;
  final bool isResolved;

  ComplaintDetail({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryName,
    required this.memberNickname,
    required this.placeName,
    required this.cityName,
    required this.districtName,
    required this.subdistrictName,
    required this.createdAt,
    required this.imageUrls,
    required this.isResolved,
  });

  factory ComplaintDetail.fromJson(Map<String, dynamic> json) {
    return ComplaintDetail(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      categoryName: json['categoryName'],
      memberNickname: json['memberNickname'],
      placeName: json['placeName'],
      cityName: json['cityName'],
      districtName: json['districtName'],
      subdistrictName: json['subdistrictName'],
      createdAt: DateTime.parse(json['createdAt']),
      imageUrls: List<String>.from(json['imageUrlList'] ?? []),
      isResolved: json['isResolved'] as bool,
    );
  }
}
