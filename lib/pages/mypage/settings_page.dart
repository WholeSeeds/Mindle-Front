import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:mindle/controllers/auth_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/main.dart';
import 'package:mindle/pages/init/set_nickname_page.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: MindleTopAppBar(title: '설정'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              title: Text("알림 설정", style: MindleTextStyles.subtitle3()),
              trailing: Icon(
                Icons.keyboard_arrow_right_sharp,
                size: 30,
                color: MindleColors.gray7,
              ),
            ),
            ListTile(
              title: Text("닉네임 설정", style: MindleTextStyles.subtitle3()),
              onTap: () {
                Get.offAll(() => RootPage());
                Get.to(() => SetNicknamePage());
              },
              trailing: Icon(
                Icons.keyboard_arrow_right_sharp,
                size: 30,
                color: MindleColors.gray7,
              ),
            ),
            ListTile(
              title: Text("공지사항", style: MindleTextStyles.subtitle3()),
              trailing: Icon(
                Icons.keyboard_arrow_right_sharp,
                size: 30,
                color: MindleColors.gray7,
              ),
            ),
            ListTile(
              title: Text("로그아웃", style: MindleTextStyles.subtitle3()),
              onTap: () {
                controller.signOut();
              },
              trailing: Icon(Icons.logout, color: MindleColors.gray7),
            ),
          ],
        ),
      ),
    );
  }
}
