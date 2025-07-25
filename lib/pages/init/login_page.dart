import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.find<AuthController>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 앱 로고
            Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Logo',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            // 하단 소셜 로그인 버튼
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.signInWithGoogle,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_icon.jpeg',
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(width: 8),
                          Text('Google로 시작하기'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: 300,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.signInWithKakao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xfffee500),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/kakao_icon.png',
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 8),
                          Text('카카오로 시작하기'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
