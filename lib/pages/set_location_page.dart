import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/location_controller.dart';

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
              // 1번 필드: '경기도' 텍스트
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('경기도', style: TextStyle(fontSize: 16)),
              ),

              SizedBox(width: 8),

              // 2번 필드: 시/군 선택
              Expanded(
                child: Obx(() {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: SizedBox(),
                      value: controller.selectedCity.value.isEmpty
                          ? null
                          : controller.selectedCity.value,
                      hint: Text('시/군 선택'),
                      items: controller.cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.selectCity(newValue);
                        }
                      },
                    ),
                  );
                }),
              ),

              SizedBox(width: 8),

              // 3번 필드: 읍/면/동 선택
              Expanded(
                child: Obx(() {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: SizedBox(),
                      value: controller.selectedNbhd.value.isEmpty
                          ? null
                          : controller.selectedNbhd.value,
                      hint: Text('읍/면/동 선택'),
                      items: controller.nbhds.map((String nbhd) {
                        return DropdownMenuItem<String>(
                          value: nbhd,
                          child: Text(nbhd),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.selectNbhd(newValue);
                        }
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
