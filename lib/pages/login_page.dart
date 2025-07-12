import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

import 'package:mindle/pages/set_nickname_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // 구글로 시작하기 (firebase)
  Future<void> signInWithGoogle() async {
    // 구글 로그인, 사용자 계정 정보 획득
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // googleUser에서 액세스 토큰과 ID 토큰 가져오기
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    log("[테스트용 ID 토큰] : ${googleAuth!.idToken!}");

    // Firebase에서 사용 가능한 구글 로그인용 credential(자격 증명) 생성
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // credential을 Firebase에 넘겨서 로그인 요청, 성공하면 유저정보 포함된 UserCredential 객체 반환
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    // 유저의 ID 토큰 요청
    final idToken = await userCredential.user?.getIdToken();
    // print(idToken);

    // TODO: 서버로  ID 토큰 전송 ...
    Get.to(SetNicknamePage());
  }

  // 카카오로 시작하기
  Future<void> signInWithKakao() async {
    var provider = OAuthProvider('oidc.kakao'); // 제공업체 id

    if (await kakao.isKakaoTalkInstalled()) {
      try {
        kakao.OAuthToken token = await kakao.UserApi.instance
            .loginWithKakaoTalk();

        // Firebase에 로그인 요청 및 ID 토큰 획득
        var credential = provider.credential(
          idToken: token.idToken,
          accessToken: token.accessToken,
        );
        final userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
        final idToken = await userCredential.user?.getIdToken();

        log("[테스트용 ID 토큰] : ${idToken!}");

        // TODO: 서버로  ID 토큰 전송 ...
        Get.to(SetNicknamePage());
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
      }
    } else {
      try {
        kakao.OAuthToken token = await kakao.UserApi.instance
            .loginWithKakaoAccount();

        // Firebase에 로그인 요청 및 ID 토큰 획득
        var credential = provider.credential(
          idToken: token.idToken,
          accessToken: token.accessToken,
        );
        final userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
        final idToken = await userCredential.user?.getIdToken();

        log("[테스트용 ID 토큰] : ${idToken!}");

        // TODO: 서버로  ID 토큰 전송 ...
        Get.to(SetNicknamePage());
      } catch (error) {
        print('카카오 계정으로 로그인 실패 $error');
      }
    }
  }

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
                      onPressed: signInWithGoogle,
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
                      onPressed: signInWithKakao,
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
