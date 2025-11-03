import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/phone_auth_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/pages/init/code_input_page.dart';
import 'package:mindle/widgets/mindle_textbutton.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';

class PhoneNumberPage extends StatelessWidget {
  const PhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PhoneAuthController>();

    void handleSubmit() {
      if (controller.formKey.currentState!.validate()) {
        controller
            .sendVerificationCode(controller.phoneNumberController.text)
            .then((_) {
              Get.to(() => CodeInputPage());
            })
            .catchError((e) {
              Get.snackbar("인증코드 전송 실패", "인증코드를 보내는 데 실패했습니다. 다시 시도해 주세요.");
            });
      }
    }

    return Scaffold(
      appBar: MindleTopAppBar(title: '휴대폰 번호 인증'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.vertical12,
              Text("휴대폰 번호 인증", style: MindleTextStyles.headline1()),
              Spacing.vertical12,
              Text(
                "인증코드를 받을 전화번호를 입력해주세요",
                style: MindleTextStyles.body1(color: MindleColors.gray1),
              ),
              SizedBox(height: 48),
              TextFormField(
                keyboardType: TextInputType.phone,
                validator: (value) => controller.validator(value),
                controller: controller.phoneNumberController,
                decoration: InputDecoration(
                  hintText: '휴대폰 번호 입력 (예: 01012345678)',
                  hintStyle: MindleTextStyles.body1(color: MindleColors.gray8),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: MindleColors.gray6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: MindleColors.mainGreen),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: MindleTextButton(
                  label: '인증코드 받기',
                  onPressed: () {
                    handleSubmit();
                  },
                  textColor: Colors.white,
                  backgroundColor: MindleColors.mainGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
