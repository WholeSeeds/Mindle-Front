import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/phone_auth_controller.dart';
import 'package:mindle/pages/init/code_input_page.dart';

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
      appBar: AppBar(title: const Text('전화번호 인증'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("인증코드를 받을 전화번호를 입력해주세요.", style: TextStyle(fontSize: 18)),
              SizedBox(height: 24),
              TextFormField(
                keyboardType: TextInputType.phone,
                validator: (value) => controller.validator(value),
                controller: controller.phoneNumberController,
                decoration: InputDecoration(
                  hintText: '전화번호 입력',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: handleSubmit,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('인증코드 받기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
