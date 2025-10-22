import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/phone_auth_controller.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';

class CodeInputPage extends StatelessWidget {
  const CodeInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PhoneAuthController>();

    void handleSubmit() {
      final smsCode = controller.codeControllers.map((c) => c.text).join();

      controller
          .signInWithPhoneNumber(smsCode)
          .then((_) {
            Get.snackbar("인증 성공", "전화번호 인증에 성공했어요!");
          })
          .catchError((e) {
            Get.snackbar("인증 실패", "전화번호 인증에 실패했어요. 다시 시도해주세요.");
          });
    }

    return Scaffold(
      appBar: MindleTopAppBar(title: '코드 입력'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("코드 입력", style: TextStyle(fontSize: 24)),
            Text(
              "문자로 전송된 인증코드를 입력하여 \n인증을 완료해주세요",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 56,
                  height: 64,
                  child: TextField(
                    controller: controller.codeControllers[index],
                    focusNode: controller.focusNodes[index],
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Color(0xFFF1F3F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Color(0xFFF1F3F5)),
                      ),
                    ),
                    onChanged: (value) {
                      // 자동 포커스 이동
                      if (value.isNotEmpty && index < 5) {
                        controller.focusNodes[index + 1].requestFocus();
                      }
                      if (value.isEmpty && index > 0) {
                        controller.focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
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
                child: const Text('입력 완료'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
