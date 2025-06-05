import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // 구글로 시작하기 (firebase)
  Future<void> signInWithGoogle() async {
    // 구글 로그인, 사용자 계정 정보 획득
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // googleUser에서 액세스 토큰과 ID 토큰 가져오기
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Firebase에서 사용 가능한 구글 로그인용 credential(자격 증명) 생성
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // credential을 Firebase에 넘겨서 로그인 요청, 성공하면 유저정보 포함된 UserCredential 객체 반환
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    // TODO: 서버로 토큰 전송 ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 로고
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
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://developers.google.com/identity/images/g-logo.png',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 8),
                        Text('Google로 시작하기'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
