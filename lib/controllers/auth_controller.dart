import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

import 'package:mindle/main.dart';
import 'package:mindle/pages/init/login_page.dart';
import 'package:mindle/pages/init/phone_number_page.dart';
import 'package:mindle/pages/init/set_nickname_page.dart';

class AuthController extends GetxController {
  late Rx<User?> _user; // FirebaseAuth로 로그인한 User 객체
  FirebaseAuth authentication = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(authentication.currentUser);
    _user.bindStream(authentication.userChanges());
    ever(_user, _handleUserChange);
  }

  _handleUserChange(User? user) {
    print("⚠️ user changed !!!");

    if (user == null) {
      // 0. 로그아웃
      Get.offAll(() => LoginPage());
    } else if (user.providerData.any((p) => p.providerId == 'phone')) {
      // 1. 전화번호 인증으로 로그인
      if (user.providerData.length == 1) {
        // 회원가입
        // TODO: 계정 연동
        Get.to(() => SetNicknamePage());
      } else {
        // TODO: 연동된 계정 안내 & 선택
        Get.offAll(() => RootPage());
      }
    } else {
      // 2. 소셜 계정으로 로그인
      final creation = user.metadata.creationTime!;
      final lastSignIn = user.metadata.lastSignInTime!;
      final isFirstLogin = creation.difference(lastSignIn).inSeconds.abs() < 1;

      if (isFirstLogin) {
        // 전화번호 인증
        Get.to(() => PhoneNumberPage());
      } else {
        Get.offAll(() => RootPage());
      }
    }
  }

  // 구글로 시작하기 (firebase)
  Future<void> signInWithGoogle() async {
    try {
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
      final userCredential = await authentication.signInWithCredential(
        credential,
      );

      // 유저의 ID 토큰 요청
      final idToken = await userCredential.user?.getIdToken();
      // TODO: 요청 헤더에 ID 토큰 저장
    } catch (error) {
      print("Login Error: $error");
      Get.snackbar("로그인 실패", "구글 로그인에 실패하였습니다.");
    }
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
        final userCredential = await authentication.signInWithCredential(
          credential,
        );
        final idToken = await userCredential.user?.getIdToken();
        // TODO: 요청 헤더에 ID 토큰 저장
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
        final userCredential = await authentication.signInWithCredential(
          credential,
        );
        final idToken = await userCredential.user?.getIdToken();
        // TODO: 요청 헤더에 ID 토큰 저장
      } catch (error) {
        print('카카오 계정으로 로그인 실패 $error');
      }
    }
  }

  // 로그아웃
  void signOut() {
    authentication.signOut();
  }
}
