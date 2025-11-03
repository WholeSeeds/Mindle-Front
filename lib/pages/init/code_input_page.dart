import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/phone_auth_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/pages/init/set_nickname_page.dart';
import 'package:mindle/widgets/mindle_textbutton.dart';
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.vertical12,
            Text("코드 입력", style: MindleTextStyles.headline1()),
            Spacing.vertical12,
            Text(
              "문자로 전송된 인증코드를 입력하여 \n인증을 완료해주세요",
              style: MindleTextStyles.body1(color: MindleColors.gray1),
            ),
            SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                final focusNode = controller.focusNodes[index];

                return SizedBox(
                  width: 56,
                  height: 60,
                  child: Obx(() {
                    final text = controller.codeTexts[index].value;
                    return TextField(
                      controller: controller.codeControllers[index],
                      focusNode: focusNode,
                      maxLength: 1,
                      autofocus: index == 0,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: MindleTextStyles.headline1().copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: text.isEmpty
                            ? Color(0xFFF1F3F5)
                            : MindleColors.mainGreen.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: text.isEmpty
                                ? Colors.white
                                : MindleColors.mainGreen,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: text.isEmpty
                                ? Colors.transparent
                                : MindleColors.mainGreen,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: MindleColors.mainGreen,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    );
                  }),
                );
              }),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: MindleTextButton(
                label: '입력 완료',
                onPressed: () {
                  handleSubmit();
                  // Get.to(() => SetNicknamePage());
                },
                textColor: Colors.white,
                backgroundColor: MindleColors.mainGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacing.vertical12,
          ],
        ),
      ),
    );
  }
}
