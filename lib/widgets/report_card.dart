import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final String title;
  final String content;
  final int numLikes;
  final int numComments;
  final String status;
  final bool hasImage;

  const ReportCard({
    super.key,
    required this.title,
    required this.content,
    required this.numLikes,
    required this.numComments,
    required this.status,
    this.hasImage = false,
  });

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;

    if (status == "accepted") {
      statusText = "접수완료";
      statusColor = Color(0xffEB5757);
    } else if (status == "solved") {
      statusText = "해결완료";
      statusColor = Color(0xff40D139);
    } else {
      statusText = "접수 전";
      statusColor = Color(0xff838383);
    }

    return SizedBox(
      height: 150,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (hasImage) ...[
                      const SizedBox(width: 16),
                      Container(
                        height: 80,
                        width: 80,
                        color: Colors.grey.shade300,
                        child: const Center(child: Icon(Icons.image, size: 30)),
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.favorite_border, size: 20),
                  const SizedBox(width: 4),
                  Text('$numLikes'),
                  const SizedBox(width: 16),
                  const Icon(Icons.comment_outlined, size: 20),
                  const SizedBox(width: 4),
                  Text('$numComments'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
