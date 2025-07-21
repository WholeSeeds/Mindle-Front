import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/location_controller.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocationController>();

    return Scaffold(
      body: Stack(
        children: [
          // 네이버 맵
          NaverMap(
            onMapReady: (naverMapController) {
              print("네이버맵 준비 완료");
              controller.setMapController(naverMapController);
            },
          ),

          // 플로팅 버튼
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                controller.isSelectingLocation.value = true;
              },
              child: const Icon(Icons.edit_location_alt),
            ),
          ),

          // 플로팅버튼 - 위치선택 바텀시트
          Obx(() {
            if (!controller.isSelectingLocation.value)
              return const SizedBox.shrink();

            return DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.35,
              maxChildSize: 0.35,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '첨부할 위치를 선택해주세요',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('공공기관이 없어요'),
                          const SizedBox(height: 16),
                          const Text('선택된 위치'),
                          const SizedBox(height: 8),
                          const Text('흠'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              controller.isSelectingLocation.value = false;
                            },
                            child: const Text('선택 완료'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
