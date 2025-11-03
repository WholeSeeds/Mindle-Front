import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/user_controller.dart';
import 'package:mindle/designs.dart';

import 'package:mindle/pages/mypage/my_complaints_page.dart';
import 'package:mindle/pages/mypage/liked_complaints_page.dart';
import 'package:mindle/pages/mypage/commented_complaints_page.dart';
import 'package:mindle/pages/mypage/settings_page.dart';
import 'package:mindle/pages/init/set_nbhd_page.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';

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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MindleTopAppBar(
        title: '마이페이지',
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => SettingsPage());
            },
            icon: SvgPicture.asset(
              'assets/icons/empty/Setting.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = userController.currentUser.value;
        if (user == null) {
          return const Center(child: Text('사용자 정보를 불러올 수 없습니다.'));
        }

        final level = min(user.contributionScore ~/ 100, 9);
        final rate = userController.myComplaintCount == 0
            ? 0.0
            : userController.myComplaintSolvedCount /
                  userController.myComplaintCount;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // 프로필 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${user.nickname} 님\n안녕하세요!",
                          style: MindleTextStyles.headline1(),
                        ),
                        Column(
                          children: [
                            Stack(
                              children: [
                                // 프로필 이미지
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                    boxShadow: [BoxShadow(color: Colors.grey)],
                                    shape: BoxShape.circle,
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        'assets/images/profile_image.jpg',
                                        // 'assets/images/no_image.jpg',
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: SvgPicture.asset(
                                    badgePathList[level],
                                    width: 28,
                                    height: 28,
                                  ),
                                ),
                              ],
                            ),

                            Spacing.vertical4,

                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/empty/Green_Location.svg',
                                ),
                                Spacing.horizontal4,
                                Text(
                                  user.subdistrict?.name ?? '동네설정 필요',
                                  style: MindleTextStyles.body3(
                                    color: MindleColors.mainGreen,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacing.vertical24,

                    // 경험치 표시
                    Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                value: rate,
                                minHeight: 10,
                                backgroundColor: MindleColors.mainGreen
                                    .withOpacity(0.1),
                                color: MindleColors.mainGreen,
                              ),
                            ),

                            // 퍼센트 말풍선
                            Positioned(
                              left:
                                  (MediaQuery.of(context).size.width - 40) *
                                      rate -
                                  30,
                              top: -8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: MindleColors.mainGreen,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  '${(rate * 100).toInt()}%',
                                  style: MindleTextStyles.body4(
                                    color: MindleColors.mainGreen,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacing.vertical8,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '해결된 민원 ',
                                  style: MindleTextStyles.body4(),
                                ),
                                Text(
                                  '/ 작성민원',
                                  style: MindleTextStyles.body4(
                                    color: MindleColors.gray2,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${userController.myComplaintSolvedCount}/${userController.myComplaintCount}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Spacing.vertical24,

              // 통계 카드
              _buildStatsContainer(
                userController.myComplaintCount.toString(),
                userController.myLikesCount.toString(),
                userController.myCommentsCount.toString(),
              ),
              Spacing.vertical24,

              // 메뉴 리스트
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      title: '동네설정',
                      onTap: () => Get.to(() => SetNbhdPage()),
                      nbhd: user.subdistrict?.name ?? '설정 필요',
                      showArrow: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsContainer(
    String myComplaintCount,
    String myLikedCount,
    String myCommentedCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: 'assets/icons/filled/Document.svg',
              title: '작성한 민원',
              count: myComplaintCount,
              onTap: () => Get.to(() => MyComplaintsPage()),
            ),
          ),
          Container(width: 1, height: 50, color: MindleColors.gray6),
          Expanded(
            child: _buildStatItem(
              icon: 'assets/icons/filled/Heart.svg',
              title: '공감한 민원',
              count: myLikedCount,
              onTap: () => Get.to(() => LikedComplaintsPage()),
            ),
          ),
          Container(width: 1, height: 50, color: MindleColors.gray6),
          Expanded(
            child: _buildStatItem(
              icon: 'assets/icons/filled/Message_square.svg',
              title: '댓글 단 민원',
              count: myCommentedCount,
              onTap: () => Get.to(() => CommentedComplaintsPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String title,
    required String count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                MindleColors.mainGreen,
                BlendMode.srcIn,
              ),
            ),
            Spacing.vertical8,
            Text(
              title,
              style: MindleTextStyles.body4(color: MindleColors.gray2),
              textAlign: TextAlign.center,
            ),
            Spacing.vertical4,
            Text(count, style: MindleTextStyles.subtitle1()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
    String nbhd = '',
    bool showArrow = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(child: Text(title, style: MindleTextStyles.subtitle3())),
              if (showArrow)
                // SvgPicture.asset(
                //   'assets/icons/empty/arrow_right.svg',
                //   width: 20,
                //   height: 20,
                //   colorFilter: ColorFilter.mode(
                //     MindleColors.gray3,
                //     BlendMode.srcIn,
                //   ),
                // )
                Text(">")
              else
                Text(
                  nbhd,
                  style: MindleTextStyles.body3(color: MindleColors.mainGreen),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
