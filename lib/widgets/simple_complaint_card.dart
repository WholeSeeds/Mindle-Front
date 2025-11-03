import 'package:flutter/material.dart';
import '../designs.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SimpleComplaintCard extends StatelessWidget {
  final String label1;
  final String label2;
  final String regionLabel;
  final int commentCount;
  final int likeCount;

  const SimpleComplaintCard({
    super.key,
    required this.label1,
    required this.label2,
    required this.regionLabel,
    required this.commentCount,
    required this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: MindleColors.white,
        border: Border.all(color: MindleColors.gray6, width: 1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label1,
              style: MindleTextStyles.body1(color: MindleColors.mainGreen),
            ),
            Text(
              label2,
              style: MindleTextStyles.body1(color: MindleColors.black),
            ),
            Spacing.vertical4,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/marker-pin-01.png',
                  width: 16,
                  height: 16,
                  color: MindleColors.gray1,
                ),
                Spacing.horizontal4,
                Text(
                  regionLabel,
                  style: MindleTextStyles.body3(color: MindleColors.gray1),
                ),
                Spacing.horizontal8,
                SvgPicture.asset(
                  'assets/icons/empty/Message_square.svg',
                  width: 16,
                  height: 16,
                  color: MindleColors.gray1,
                ),
                Spacing.horizontal4,
                Text(
                  commentCount.toString(),
                  style: MindleTextStyles.body3(color: MindleColors.gray1),
                ),
                Spacing.horizontal8,
                SvgPicture.asset(
                  'assets/icons/empty/Heart.svg',
                  width: 16,
                  height: 16,
                  color: MindleColors.gray1,
                ),
                Spacing.horizontal4,
                Text(
                  likeCount.toString(),
                  style: MindleTextStyles.body3(color: MindleColors.gray1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
