import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/auth_controller.dart';
import 'package:mindle/designs.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.find<AuthController>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              // 앱 로고
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  SvgPicture.asset(
                    'assets/icons/filled/Logo.svg',
                    height: 32,
                    width: 32,
                    color: MindleColors.mainGreen,
                  ),
                  Spacing.vertical30,
                  SvgPicture.asset('assets/images/Mindle_Title.svg'),
                  Spacing.vertical12,
                  Text(
                    '민원 들으러 레츠고!',
                    style: MindleTextStyles.body1(
                      color: MindleColors.mainGreen,
                    ),
                  ),
                  Spacing.vertical30,
                  Text(
                    '경기도 주민을 위한 간편 불편사항 신고 애플리케이션',
                    style: MindleTextStyles.body4(color: MindleColors.gray1),
                  ),
                ],
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
                      height: 60,
                      child: ElevatedButton(
                        onPressed: controller.signInWithKakao,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfffee500),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                            Spacing.horizontal8,
                            Text('카카오로 시작하기'),
                          ],
                        ),
                      ),
                    ),
                    Spacing.vertical12,
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: controller.signInWithGoogle,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                            Spacing.horizontal8,
                            Text('Google로 시작하기'),
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
      ),
    );
  }
}
