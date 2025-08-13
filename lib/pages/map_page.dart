import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/widgets/location_select_panel.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocationController>();

    return Scaffold(
      body: Obx(() {
        final isSelecting = controller.isSelectingLocation.value;

        return Column(
          children: [
            // 지도 영역
            Expanded(
              flex: isSelecting ? 65 : 100, // true면 65%, false면 100%
              child: NaverMap(
                onMapReady: (naverMapController) {
                  print("네이버맵 준비 완료");
                  controller.setMapController(naverMapController);
                },
                onMapTapped: (npoint, nlatlng) {
                  print("지도 탭됨");
                  if (isSelecting) {
                    // 위치 선택 모드일 때만 동작
                    controller.selectLocationToLatLng(nlatlng);
                  }
                },
              ),
            ),

            // 선택 패널
            if (isSelecting)
              Expanded(
                flex: 35, // 화면 35%
                child: LocationSelectPanel(),
              ),
          ],
        );
      }),

      // 플로팅 버튼
      floatingActionButton: Obx(() {
        final isSelecting = controller.isSelectingLocation.value;

        if (isSelecting) {
          return FloatingActionButton(
            onPressed: () {
              controller.isSelectingLocation.value = false; // 닫기
            },
            child: const Icon(Icons.close),
          );
        } else {
          return FloatingActionButton(
            onPressed: () {
              controller.isSelectingLocation.value = true; // 열기
              controller.initSelectedLocation();
            },
            child: const Icon(Icons.edit_location_alt),
          );
        }
      }),
    );
  }
}
