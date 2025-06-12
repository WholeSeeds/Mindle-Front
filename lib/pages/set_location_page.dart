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
            '위도: ${controller.latitude.value}\n경도: ${controller.longitude.value}',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          );
        }),
      ),
    );
  }
}
