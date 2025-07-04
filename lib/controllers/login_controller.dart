import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

import 'package:mindle/main.dart';
import 'package:mindle/pages/login_page.dart';
import 'package:mindle/pages/set_nickname_page.dart';

class LoginController extends GetxController {
  late Rx<User?> _user; // FirebaseAuth로 로그인한 User 객체
  FirebaseAuth authentication = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(authentication.currentUser);
    _user.bindStream(authentication.userChanges());
    ever(_user, _moveToPage);
  }

  _moveToPage(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      // 첫 로그인이면
      // Get.to(() => SetNicknamePage());
      Get.offAll(() => RootPage());
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
      // print(idToken);

      // TODO: 서버로  ID 토큰 전송 ...
      // Get.to(SetNicknamePage());
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

        // TODO: 서버로  ID 토큰 전송 ...
        // Get.to(SetNicknamePage());
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

        // TODO: 서버로  ID 토큰 전송 ...
        // Get.to(SetNicknamePage());
      } catch (error) {
        print('카카오 계정으로 로그인 실패 $error');
      }
    }
  }
}
