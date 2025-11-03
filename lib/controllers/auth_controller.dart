import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:mindle/services/token_service.dart';
import 'package:mindle/pages/init/login_page.dart';
import 'package:mindle/pages/init/phone_number_page.dart';
import 'package:mindle/pages/init/set_nickname_page.dart';
import 'package:mindle/pages/init/List_of_linked_accounts_page.dart';
import 'package:mindle/main.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TokenService _tokenService = Get.find<TokenService>();

  FirebaseAuth authentication = FirebaseAuth.instance;
  Rx<User?> _user = Rx<User?>(FirebaseAuth.instance.currentUser);

  // UserController에서 사용할 수 있도록 public getter 추가
  Rx<User?> get user => _user;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(_auth.currentUser);
    _user.bindStream(_auth.userChanges());
    ever(_user, _handleUserChange);
  }

  /// 🔄 유저 상태 변경 감지
  Future<void> _handleUserChange(User? user) async {
    print("⚠️ Firebase user changed: ${user?.email}");

    if (user == null) {
      Get.offAll(() => LoginPage());
      return;
    }

    try {
      // Firebase → 서버 로그인
      final token = await user.getIdToken();
      await _tokenService.loginWithToken(token);

      // 로그인 성공 후 다음 페이지로
      _navigateAfterLogin(user);
    } catch (e) {
      print("❌ 서버 로그인 실패: $e");
      Get.snackbar('로그인 실패', '서버 인증 중 오류가 발생했습니다.');
      signOut();
    }
  }

  /// 📍 로그인 후 페이지 전환
  void _navigateAfterLogin(User user) {
    print(
      " navigateAfterLogin${(user.metadata.creationTime!.difference(user.metadata.lastSignInTime!).inSeconds)}",
    );
    final isFirstLogin =
        (user.metadata.creationTime!
                .difference(user.metadata.lastSignInTime!)
                .inSeconds)
            .abs() <
        11111111;
    if (isFirstLogin) {
      // if (user.providerData.length == 1) {
      //   Get.to(() => SetNicknamePage());
      // } else {
      //   Get.to(() => PhoneNumberPage());
      // }
      // TODO: 수정할 로직
      Get.offAll(() => RootPage());
      if (user.phoneNumber == null || user.phoneNumber!.isEmpty) {
        Get.to(() => PhoneNumberPage());
      } else {}
    }
  }

  /// ✅ 공통 소셜 로그인 진입점
  Future<void> signInWithProvider(String providerId) async {
    try {
      final credential = await _getSocialCredential(providerId);
      if (credential == null) return;

      final userCredential = await _auth.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();

      if (idToken != null) {
        _tokenService.setToken(idToken);
        await _tokenService.loginWithToken(idToken);
      }
    } catch (e) {
      print("🔥 $providerId 로그인 실패: $e");
      Get.snackbar("로그인 실패", "다시 시도해주세요.");
    }
  }

  /// 🔐 providerId 기반 credential 발급
  Future<AuthCredential?> _getSocialCredential(String providerId) async {
    switch (providerId) {
      case 'google.com':
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null;
        final googleAuth = await googleUser.authentication;
        return GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

      case 'oidc.kakao':
        final provider = OAuthProvider('oidc.kakao');
        final kakao.OAuthToken token = await (await kakao.isKakaoTalkInstalled()
            ? kakao.UserApi.instance.loginWithKakaoTalk()
            : kakao.UserApi.instance.loginWithKakaoAccount());
        return provider.credential(
          idToken: token.idToken,
          accessToken: token.accessToken,
        );

      default:
        return null;
    }
  }

  /// 🔗 계정 연동
  Future<bool> tryAccountLinking(PhoneAuthCredential phoneCredential) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await currentUser.linkWithCredential(phoneCredential);
      return true;
    } catch (e) {
      if (e.toString().contains('already-exists') ||
          e.toString().contains('credential-already-in-use')) {
        await _handleExistingPhoneAccount(phoneCredential);
        return false;
      } else {
        Get.snackbar('연결 실패', 'Account Linking에 실패했습니다.');
        return false;
      }
    }
  }

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
          () => ListOfLinkedAccountsPage(
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
      AuthCredential? credential = await getSocialCredential('google.com');
      if (credential == null) return;

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
    if (await kakao.isKakaoTalkInstalled()) {
      try {
        AuthCredential? credential = await getSocialCredential('oidc.kakao');
        if (credential == null) return;

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
        AuthCredential? credential = await getSocialCredential('oidc.kakao');
        if (credential == null) return;

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
      // 구글 로그인, 사용자 계정 정보 획득
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      // googleUser에서 액세스 토큰과 ID 토큰 가져오기
      final googleAuth = await googleUser.authentication;

      // Firebase에서 사용 가능한 구글 로그인용 credential(자격 증명) 생성
      return GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    } else if (providerId == 'oidc.kakao') {
      var provider = OAuthProvider('oidc.kakao'); // 제공업체 id
      kakao.OAuthToken token;
      if (await kakao.isKakaoTalkInstalled()) {
        token = await kakao.UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await kakao.UserApi.instance.loginWithKakaoAccount();
      }
      // Firebase에 로그인 요청 및 ID 토큰 획득
      return provider.credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );
    }
    return null;
  }

  /// 🚪 로그아웃
  Future<void> signOut() async {
    _tokenService.clearToken();
    await _auth.signOut();
    await GoogleSignIn().signOut();
    Get.offAll(() => LoginPage());
  }
}
