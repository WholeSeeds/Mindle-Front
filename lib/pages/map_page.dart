import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/widgets/select_bottomsheet.dart';

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
                controller.isSelectingLocation = true;
                controller.initSelectedLocation();
                // 바텀 시트 열기
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  showDragHandle: true,
                  builder: (_) {
                    return SelectBottomSheet();
                  },
                );
              },
              child: const Icon(Icons.edit_location_alt),
            ),
          ),
        ],
      ),
    );
  }
}
