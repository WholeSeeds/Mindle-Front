import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

import 'package:mindle/main.dart';
import 'package:mindle/pages/init/login_page.dart';
import 'package:mindle/pages/init/phone_number_page.dart';
import 'package:mindle/pages/init/set_nickname_page.dart';
import 'package:mindle/pages/init/List_of_linked_accounts.dart';

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

  _handleUserChange(User? user) async {
    print("⚠️ user changed !!!");
    print("User: ${user?.email}");
    print(
      "Provider data: ${user?.providerData.map((p) => p.providerId).toList()}",
    );

    if (user == null) {
      // 0. 로그아웃
      Get.offAll(() => LoginPage());
    } else if (user.providerData.any((p) => p.providerId == 'phone')) {
      // 1. 전화번호 인증으로 로그인
      if (user.providerData.length == 1) {
        // 전화번호만 있는 경우
        Get.to(() => SetNicknamePage());
      } else {
        // 이미 연동된 계정들이 있는 경우 - AccountLinking 성공
        print("Account Linking 완료 - 동일 UID: ${user.uid}");
        Get.offAll(() => RootPage());
      }
    } else {
      // 2. 소셜 계정으로 로그인 - 전화번호 인증 필요
      final creation = user.metadata.creationTime!;
      final lastSignIn = user.metadata.lastSignInTime!;
      final isFirstLogin = creation.difference(lastSignIn).inSeconds.abs() < 1;

      if (isFirstLogin) {
        Get.to(() => PhoneNumberPage());
      } else {
        Get.offAll(() => RootPage());
      }
    }
  }

  // Account Linking 시도
  Future<bool> tryAccountLinking(PhoneAuthCredential phoneCredential) async {
    try {
      User? currentUser = authentication.currentUser;
      if (currentUser == null) return false;

      await currentUser.linkWithCredential(phoneCredential);

      return true;
    } catch (e) {
      if (e.toString().contains('already-exists') ||
          e.toString().contains('credential-already-in-use')) {
        // 이미 해당 전화번호로 등록된 계정이 있는 경우 - 계정 선택 페이지로
        await _handleExistingPhoneAccount(phoneCredential);
        return false;
      } else {
        Get.snackbar('연결 실패', 'Account Linking에 실패했습니다.');
        return false;
      }
    }
  }

  // 이미 존재하는 전화번호 계정 처리
  Future<void> _handleExistingPhoneAccount(
    PhoneAuthCredential phoneCredential,
  ) async {
    try {
      // 현재 소셜 사용자 정보 임시 저장
      User? socialUser = authentication.currentUser;
      Map<String, dynamic> socialUserInfo = {
        'email': socialUser?.email,
        'displayName': socialUser?.displayName,
        'providerId': socialUser?.providerData.first.providerId,
      };

      // 기존 전화번호 계정으로 로그인
      UserCredential phoneUserCredential = await authentication
          .signInWithCredential(phoneCredential);
      User? phoneUser = phoneUserCredential.user;

      if (phoneUser != null) {
        List<LinkedAccountInfo> existingAccounts = phoneUser.providerData.map((
          provider,
        ) {
          return LinkedAccountInfo(
            providerId: provider.providerId,
            email: provider.email,
            displayName: provider.displayName,
          );
        }).toList();

        // 리스트 호출(연동된 계정)
        Get.to(
          () => ListOfLinkedAccounts(
            phoneNumber: phoneUser.phoneNumber ?? '',
            existingAccounts: existingAccounts,
            currentSocialUser: socialUserInfo,
          ),
        );
      }
    } catch (e) {
      print("기존 전화번호 계정 처리 오류: $e");
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

  // 헬퍼 함수
  Future<AuthCredential?> getSocialCredential(String providerId) async {
    if (providerId == 'google.com') {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      return GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    } else if (providerId == 'oidc.kakao') {
      var provider = OAuthProvider('oidc.kakao');
      kakao.OAuthToken token;
      if (await kakao.isKakaoTalkInstalled()) {
        token = await kakao.UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await kakao.UserApi.instance.loginWithKakaoAccount();
      }
      return provider.credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );
    }
    return null;
  }

  // 로그아웃
  void signOut() {
    authentication.signOut();
  }
}
