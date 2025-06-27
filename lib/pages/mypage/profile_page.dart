import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mindle/pages/mypage/my_complaints_page.dart';
import 'package:mindle/pages/mypage/liked_complaints_page.dart';
import 'package:mindle/pages/mypage/commented_complaints_page.dart';
import 'package:mindle/pages/mypage/settings_page.dart';
import 'package:mindle/pages/set_nbhd_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => SettingsPage());
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Stack(
              children: [
                // 프로필 이미지
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    boxShadow: [BoxShadow(color: Colors.grey)],
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/profile_image.jpg'),
                    ),
                  ),
                ),
                // 등급 배지
                Positioned(
                  right: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.amber)],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.green),
              Text(
                "세종대왕면",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Level 진행바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('내 레벨', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('다음 레벨까지 30%'),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.7, // 예시로 70% 진행
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text("작성한 민원수: 4개"), Text("해결된 민원수: 2개")],
          ),
          SizedBox(height: 36),
          // 메뉴 리스트
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('내가 작성한 민원'),
                trailing: Text("119개", style: TextStyle(fontSize: 16)),
                onTap: () {
                  Get.to(() => MyComplaintsPage());
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite_border),
                title: Text('내가 공감한 민원'),
                trailing: Text("3개", style: TextStyle(fontSize: 16)),
                onTap: () {
                  Get.to(() => LikedComplaintsPage());
                },
              ),
              ListTile(
                leading: Icon(Icons.comment),
                title: Text('내가 댓글 단 민원'),
                trailing: Text("27개", style: TextStyle(fontSize: 16)),
                onTap: () {
                  Get.to(() => CommentedComplaintsPage());
                },
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('동네 설정'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Get.to(() => SetNbhdPage());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
