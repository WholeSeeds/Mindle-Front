import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:mindle/controllers/auth_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text("설정"), centerTitle: true),
      body: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            title: Text("알림 설정"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text("공지사항"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text("로그아웃"),
            onTap: () {
              controller.signOut();
            },
            trailing: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
