import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/auth_controller.dart';

class PhoneAuthController extends GetxController {
  final authController = Get.find<AuthController>(); // check

  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final verificationId = ''.obs;

  final codeSent = false.obs; // 인증번호 전송 여부

  // 인증코드 입력 페이지 관련 변수
  final List<TextEditingController> codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  // 계정 연동 관련
  final isGoogleLinked = false.obs;
  final isKakaoLinked = false.obs;
  final isNaverLinked = false.obs;

  @override
  void onClose() {
    phoneNumberController.dispose();

    for (final v in codeControllers) {
      v.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }

    super.onClose();
  }

  // 전화번호 유효성 검증
  String? validator(String? value) {
    if (value == null || value.isEmpty) return "전화번호를 입력해주세요.";
    if (!GetUtils.isPhoneNumber(value)) return "전화번호 형식이 올바르지 않습니다";
    return null;
  }

  // 전화번호로 인증코드 전송
  Future<void> sendVerificationCode(String phoneNumber) async {
    // 한국 번호 기준 -> E164로 변환
    String validPhoneNumber = '';
    if (phoneNumber.startsWith('0')) {
      String numericPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
      validPhoneNumber = '+82 ${numericPhoneNumber.substring(1)}';
    }

    await authController.authentication.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: '+82 65-0333-0708', // TODO: 배포 전 validPhoneNumber로 변경
      verificationCompleted: (credential) async {
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
        // await authController.authentication.signInWithCredential(credential);
      },
      verificationFailed: (e) async {
        // 인증코드 전송 실패
        print("❌ verificationFailed: $e");
      },
      codeSent: (verificationId, resendingToken) async {
        // 인증코드 전송 성공
        print("✅ codeSent!");
        this.verificationId.value = verificationId;
        codeSent.value = true;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // Auto-resolution timed out...
        print("자동인증 시간 초과");
      },
    );
  }

  // 인증 완료 후
  void onVerificationComplete(PhoneAuthCredential credential) async {
    // AuthController의 Account Linking 시도
    bool linkingSuccess = await Get.find<AuthController>().tryAccountLinking(
      credential,
    );

    if (!linkingSuccess) {
      // Account Linking 실패 시 추가 처리가 필요할 수 있음
      print("Account Linking 실패 - 계정 병합 프로세스 진행");
    }
  }

  // 전화번호 인증으로 로그인
  Future<void> signInWithPhoneNumber(String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId.value,
      smsCode: smsCode,
    );

    await authController.authentication.signInWithCredential(credential);
  }
}
