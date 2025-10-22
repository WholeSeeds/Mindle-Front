import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mindle/controllers/nbhd_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/widgets/dropdown_field.dart';
import 'package:mindle/widgets/mindle_textbutton.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';

// 동네 설정 페이지
class SetNbhdPage extends StatelessWidget {
  final controller = Get.find<NbhdController>();

  SetNbhdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MindleTopAppBar(title: '동네 설정'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text('거주하고 계신 동네를\n선택해주세요', style: MindleTextStyles.headline1()),
            SizedBox(height: 8),
            Text(
              '현재 거주하시는 동네를 선택해주세요',
              style: MindleTextStyles.body1(color: MindleColors.gray1),
            ),
            SizedBox(height: 30),
            Text('경기도', style: TextStyle(fontSize: 16)),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: DropdownField(
                  hint: '시/군 선택',
                  value: controller.selectedFirst.value,
                  items: controller.firstList,
                  onChanged: controller.selectFirst,
                ),
              ),
            ),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: DropdownField(
                  hint: '구/읍/면/동 선택',
                  value: controller.selectedSecond.value,
                  items: controller.secondList,
                  onChanged: controller.selectSecond,
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.thirdList.isNotEmpty,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: SizedBox(
                  width: 150,
                  child: DropdownField(
                    hint: '동 선택',
                    value: controller.selectedThird.value,
                    items: controller.thirdList,
                    onChanged: controller.selectThird,
                  ),
                ),
              ),
            ),

            Spacer(), // 👈 남은 공간 다 차지 -> 버튼이 맨 아래로 밀림

            SizedBox(
              width: double.infinity,
              child: MindleTextButton(
                label: '완료',
                onPressed: () => Get.toNamed('/'),
              ),
            ),
            SizedBox(height: 20), // 👈 버튼과 화면 하단 간격
          ],
        ),
      ),
    );
  }
}
