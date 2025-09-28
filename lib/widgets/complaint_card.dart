import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/models/complaint.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final VoidCallback? onTap;

  const ComplaintCard({super.key, required this.complaint, this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = complaint.title;
    final content = complaint.content;
    final numLikes = complaint.numLikes;
    final numComments = complaint.numComments;
    final complaintStatus = complaint.complaintStatus;
    final hasImage = complaint.hasImage;

    // TODO: complaint 모델 필드에 위치정보 추가해서 사용하기
    final String? location = "의정부시 호원동"; // 임시 위치 정보
    // final String? location = null; // 임시 위치 정보

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (location != null)
                  ? Text(
                      location,
                      style: MindleTextStyles.body3(
                        color: MindleColors.mainGreen,
                      ).copyWith(fontWeight: FontWeight.w800),
                    )
                  : const SizedBox.shrink(),
              if (location != null) const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasImage) ...[
                    Container(
                      height: 100,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Icon(
                          Icons.image,
                          size: 32,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: MindleTextStyles.subtitle3(),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          content,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: MindleTextStyles.body4(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Divider(color: MindleColors.gray6, thickness: 1),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/empty/Heart.svg',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '$numLikes',
                    style: MindleTextStyles.body2(color: MindleColors.gray1),
                  ),
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    'assets/icons/empty/Message_square.svg',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '$numComments',
                    style: MindleTextStyles.body2(color: MindleColors.gray1),
                  ),
                  const Spacer(),
                  complaintStatus.icon,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
