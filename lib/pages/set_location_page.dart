import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/location_controller.dart';

class DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final Function(String) onChanged;

  const DropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: SizedBox(),
        value: value == null || value!.isEmpty ? null : value,
        hint: Text(hint),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }
}

class SetLocationPage extends StatelessWidget {
  final controller = Get.find<LocationController>();

  SetLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 현재 위치 가져오기
    controller.getCurrentPosition();

    return Scaffold(
      appBar: AppBar(title: Text('동네 설정'), centerTitle: true),
      body: Column(
        children: [
          // 현재 위치 확인 텍스트
          Obx(() {
            return Text(
              '거주하고 계신 동네가 \n${controller.address.value}이신가요? \n 아니라면 거주하고 계신 동네를 선택해주세요.',
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
                    items: controller.firstList,
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
                    items: controller.secondList,
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
                  items: controller.thirdList,
                  onChanged: controller.selectThird,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
