import 'package:flutter/material.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/models/public_place.dart';
import 'package:mindle/models/region_info.dart';
import 'package:mindle/pages/complaint_form_page.dart';
import 'package:get/get.dart';

class SelectBottomSheet extends StatelessWidget {
  SelectBottomSheet({super.key});

  final controller = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      maxChildSize: 0.4,
      builder: (context, scrollController) {
        return Stack(
          children: [
            // 스크롤 가능한 컨테이너
            SingleChildScrollView(
              controller: scrollController,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '첨부할 위치를 선택해주세요',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '? 공공기관이 없어요',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.blueGrey,
                      ),
                    ),
                    // 선택된 위치 정보 스트링 표시
                    const SizedBox(height: 16),
                    Obx(() => Text(controller.selectedLocationString.value)),
                    const SizedBox(height: 20),
                  ],
                ),
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
                    // 민원 작성 로직
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
      },
    );
  }
}
