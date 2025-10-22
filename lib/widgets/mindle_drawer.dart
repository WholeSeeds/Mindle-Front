import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mindle/pages/init/set_nbhd_page.dart';
import 'package:mindle/pages/mypage/commented_complaints_page.dart';
import 'package:mindle/pages/mypage/liked_complaints_page.dart';
import 'package:mindle/pages/mypage/my_complaints_page.dart';
import 'package:mindle/pages/mypage/settings_page.dart';
import '../designs.dart';
import '../controllers/bottom_nav_controller.dart';
import '../controllers/location_controller.dart';

class MindleDrawer extends StatelessWidget {
  const MindleDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();
    final locationController = Get.find<LocationController>();

    return Drawer(
      backgroundColor: MindleColors.gray3,
      width: MediaQuery.of(context).size.width * 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: 24),
                    onPressed: () => Get.back(),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    'assets/icons/filled/Logo.svg',
                    height: 24,
                    width: 24,
                    color: MindleColors.mainGreen,
                  ),
                ],
              ),
            ),
            // 메뉴 아이템들
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // 민원 작성
                  _DrawerDivider(title: '민원작성'),
                  _DrawerItem(
                    title: '민원지도',
                    onTap: () {
                      controller.changeIndex(2);
                      Navigator.pop(context);
                    },
                  ),
                  _DrawerItem(
                    title: '글쓰기',
                    onTap: () {
                      locationController.enableSelectingLocation();
                      controller.changeIndex(2);
                      Navigator.pop(context);
                    },
                  ),

                  // 민원 목록
                  _DrawerDivider(title: '민원목록'),
                  _DrawerItem(
                    title: '민원목록보기',
                    onTap: () {
                      controller.changeIndex(3);
                      Navigator.pop(context);
                    },
                  ),

                  // 통계
                  _DrawerDivider(title: '통계'),
                  _DrawerItem(
                    title: '통계자료보기',
                    onTap: () {
                      controller.changeIndex(1);
                      Navigator.pop(context);
                    },
                  ),

                  // 마이페이지
                  _DrawerDivider(title: '마이페이지'),
                  _DrawerItem(
                    title: '내가 작성한 민원',
                    onTap: () => Get.to(() => MyComplaintsPage()),
                  ),
                  _DrawerItem(
                    title: '내가 공감한 민원',
                    onTap: () => Get.to(() => LikedComplaintsPage()),
                  ),
                  _DrawerItem(
                    title: '내가 단 댓글',
                    onTap: () => Get.to(() => CommentedComplaintsPage()),
                  ),
                  _DrawerItem(
                    title: '동네설정',
                    onTap: () => Get.to(() => SetNbhdPage()),
                  ),
                  _DrawerItem(
                    title: '설정',
                    onTap: () => Get.to(() => SettingsPage()),
                  ),
                ],
              ),
            ),
            // // 하단 버전 정보
            // Container(
            //   padding: const EdgeInsets.all(20),
            //   child: Text(
            //     'Version 1.0.0',
            //     style: MindleTextStyles.body5(color: MindleColors.gray8),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: MindleTextStyles.subtitle3(color: MindleColors.gray1),
        ),
      ),
    );
  }
}

class _DrawerDivider extends StatelessWidget {
  final String title;

  const _DrawerDivider({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacing.vertical20,
        Text(
          title,
          style: MindleTextStyles.body4(
            color: MindleColors.gray5,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(color: MindleColors.gray6),
      ],
    );
  }
}
