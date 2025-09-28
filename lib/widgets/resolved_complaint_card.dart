import 'package:flutter/material.dart';
import 'package:mindle/models/complaint.dart';
import '../designs.dart';

class ResolvedComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final VoidCallback? onTap;

  const ResolvedComplaintCard({super.key, required this.complaint, this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: 이미지 URL과 기타 정보 하드코딩된 부분을 실제 데이터로 교체
    const String afterImageUrl = 'https://picsum.photos/280/120?random=3';
    const location = '서울시 강남구';
    final status = complaint.complaintStatus;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: MindleColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MindleColors.black.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 완료 배지
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 해결 후 이미지
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MindleColors.gray4,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12), // 윗부분만 둥글게
                      bottom: Radius.zero, // 아랫부분은 직각
                    ),
                    child: Image.network(
                      afterImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: MindleColors.gray5,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목
                      Text(
                        complaint.title,
                        style: MindleTextStyles.subtitle3(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: MindleColors.gray5,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: MindleTextStyles.body5(
                                color: MindleColors.gray5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Align(
                        alignment: Alignment.centerRight, // Column의 오른쪽 끝으로 이동
                        child: status.icon,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
