import 'package:flutter/material.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/models/public_place.dart';
import 'package:mindle/models/region_info.dart';
import 'package:mindle/pages/complaint_form_page.dart';
import 'package:get/get.dart';

class LocationSelectPanel extends StatelessWidget {
  LocationSelectPanel({super.key});

  final controller = Get.find<LocationController>();

  static const Color mainGreen = Color(0xFF00D482);
  static const Color gray4 = Color(0xFFF1F3F5);

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
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller.selectedLocationString.value.isEmpty
                          ? gray4
                          : mainGreen,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.selectedLocationString.value,
                    style: const TextStyle(fontSize: 12, color: mainGreen),
                    overflow: TextOverflow.ellipsis, // overflow 시 ...
                    maxLines: 1, // 한 줄로 제한
                  ),
                ),
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
                        place:
                            controller.selectedPlace.value ??
                            PublicPlace.empty(),
                        regionInfo:
                            controller.selectedRegionInfo.value ??
                            RegionInfo.empty(),
                      ),
                    ) ??
                    controller.initSelectedLocation();
              },
              child: const Text('민원 작성하기', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }
}
