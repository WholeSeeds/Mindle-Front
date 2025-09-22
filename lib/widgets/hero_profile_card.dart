import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../designs.dart';
import '../models/user.dart';

class HeroProfileCard extends StatelessWidget {
  final User user;

  const HeroProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final level = user.level ?? 1;
    final name = user.name ?? '이름 없음';
    final profileImageUrl = user.profileImageUrl ?? '';
    final complaintCount = user.complaintCount ?? 0;
    final solvedComplaintCount = user.solvedComplaintCount ?? 0;

    final badgePathList = [
      'assets/icons/Badge1.svg',
      'assets/icons/Badge2.svg',
      'assets/icons/Badge3.svg',
      'assets/icons/Badge4.svg',
      'assets/icons/Badge5.svg',
      'assets/icons/Badge6.svg',
      'assets/icons/Badge7.svg',
      'assets/icons/Badge8.svg',
      'assets/icons/Badge9.svg',
      'assets/icons/Badge10.svg',
    ];

    final size = MediaQuery.of(context).size.width * 0.08;

    return Container(
      padding: const EdgeInsets.all(1),
      child: Row(
        children: [
          // 레벨 배지
          SvgPicture.asset(badgePathList[level - 1], width: size, height: size),
          const SizedBox(width: 20),
          // 프로필 이미지
          CircleAvatar(
            radius: 28,
            backgroundImage: profileImageUrl.isNotEmpty
                ? NetworkImage(profileImageUrl)
                : null,
            backgroundColor: MindleColors.gray4,
            child: profileImageUrl.isEmpty
                ? Icon(Icons.person, size: 30, color: MindleColors.gray2)
                : null,
          ),
          const SizedBox(width: 16),
          // 이름 및 통계
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: MindleTextStyles.body1()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '작성한 민원 $complaintCount',
                      style: MindleTextStyles.body4(color: MindleColors.gray2),
                    ),
                    Text(
                      '해결된 민원 $solvedComplaintCount',
                      style: MindleTextStyles.body4(color: MindleColors.gray2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
