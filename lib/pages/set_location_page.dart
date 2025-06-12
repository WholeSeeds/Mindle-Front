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
      body: Center(
        child: Obx(() {
          return Text(
            '거주하고 계신 행정동이 \n${controller.address.value}이신가요? \n 아니라면 행정동을 선택해주세요.',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          );
        }),
      ),
    );
  }
}
