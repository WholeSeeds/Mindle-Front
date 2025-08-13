import 'package:flutter/material.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/pages/complaint_form_page.dart';
import 'package:get/get.dart';
import 'package:mindle/widgets/icon_textbox.dart';

class LocationSelectPanel extends StatelessWidget {
  LocationSelectPanel({super.key});

  final controller = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 내용
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                '첨부할 위치를 선택해주세요',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '? 공공기관이 없어요',
                style: TextStyle(fontSize: 10, color: Colors.blueGrey),
              ),
              const SizedBox(height: 16),
              const Text(
                '선택된 위치',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),

              const SizedBox(height: 3),
              // 선택된 위치 정보
              Obx(
                () =>
                    IconTextBox(text: controller.selectedLocationString.value),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),

        // 민원 작성 버튼
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.to(
                  () => ComplaintFormPage(
                    place: controller.selectedPlace.value,
                    regionInfo: controller.selectedRegionInfo.value,
                  ),
                );
              },
              child: const Text('민원 작성하기', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }
}
