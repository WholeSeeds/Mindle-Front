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
    final UserController userController = Get.put(UserController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // TODO: MindleTopAppBar로 통일하기: 위젯에 우측 아이콘 추가 필요
        title: Text('마이페이지', style: MindleTextStyles.subtitle2()),
        centerTitle: true,
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

                            const SizedBox(height: 4),

                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/empty/Green_Location.svg',
                                ),
                                const SizedBox(width: 4),
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
                    const SizedBox(height: 24),

                    // 경험치 표시
                    Column(
                      children: [
                        LinearProgressIndicator(
                          value: 0.7, // 예시로 70% 진행
                          minHeight: 10,
                          backgroundColor: MindleColors.mainGreen.withOpacity(
                            0.1,
                          ),
                          color: MindleColors.mainGreen,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        SizedBox(height: 8),
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
                            Text('7/12'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 통계 카드
              _buildStatsContainer(),
              const SizedBox(height: 24),

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
                      title: '동네 설정',
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

  Widget _buildStatsContainer() {
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
              count: '15',
              onTap: () => Get.to(() => MyComplaintsPage()),
            ),
          ),
          Container(width: 1, height: 50, color: MindleColors.gray6),
          Expanded(
            child: _buildStatItem(
              icon: 'assets/icons/filled/Heart.svg',
              title: '공감한 민원',
              count: '23',
              onTap: () => Get.to(() => LikedComplaintsPage()),
            ),
          ),
          Container(width: 1, height: 50, color: MindleColors.gray6),
          Expanded(
            child: _buildStatItem(
              icon: 'assets/icons/filled/Message_square.svg',
              title: '댓글 단 민원',
              count: '8',
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
            const SizedBox(height: 8),
            Text(
              title,
              style: MindleTextStyles.body4(color: MindleColors.gray2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
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
              Expanded(child: Text(title, style: MindleTextStyles.subtitle2())),
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
