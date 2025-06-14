import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mindle/controllers/nbhd_controller.dart';
import 'package:mindle/widgets/dropdown_field.dart';

// 동네 설정 페이지
class SetNbhdPage extends StatelessWidget {
  final controller = Get.find<NbhdController>();

  SetNbhdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('동네 설정'), centerTitle: true),
      body: Column(
        children: [
          // 안내 문구
          Obx(() {
            return Text(
              '거주하고 계신 동네를 선택해주세요.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            );
          }),

          SizedBox(height: 30),

          // 주소 선택 UI
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text('경기도', style: TextStyle(fontSize: 16)),
              ),

              SizedBox(width: 8),

              // 1번 필드: 시/군 선택
              Expanded(
                child: Obx(() {
                  return DropdownField(
                    hint: '시/군 선택',
                    value: controller.selectedFirst.value,
                    items: controller.firstList.toList(),
                    onChanged: controller.selectFirst,
                  );
                }),
              ),

              SizedBox(width: 8),

              // 2번 필드: 구/읍/면/동 선택
              Obx(
                () => Expanded(
                  child: DropdownField(
                    hint: '구/읍/면/동 선택',
                    value: controller.selectedSecond.value,
                    items: controller.secondList.toList(),
                    onChanged: controller.selectSecond,
                  ),
                ),
              ),
            ],
          ),
          // 3번 필드: 동 선택
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
                  items: controller.thirdList.toList(),
                  onChanged: controller.selectThird,
                ),
              ),
            ),
          ),

          FilledButton(
            onPressed: () => Get.toNamed('/'),
            child: const Text('완료'),
          ),
        ],
      ),
    );
  }
}
