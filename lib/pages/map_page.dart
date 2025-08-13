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

    return Obx(() {
      final isSelecting = controller.isSelectingLocation.value;

      return PopScope(
        canPop: !isSelecting,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && isSelecting) {
            controller.disableSelectingLocation();
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: isSelecting ? 65 : 100,
                child: NaverMap(
                  options: NaverMapViewOptions(
                    consumeSymbolTapEvents:
                        false, // 심볼 여부와 상관없이 onMapTapped 이벤트가 trigger 되도록 설정
                  ),
                  onMapReady: controller.setMapController,
                  onMapTapped: (npoint, nlatlng) {
                    print("지도 탭됨");
                    if (isSelecting) {
                      controller.selectLocationToLatLng(nlatlng);
                    }
                  },
                ),
              ),
              if (isSelecting) Expanded(flex: 35, child: LocationSelectPanel()),
            ],
          ),

          // 플로팅 버튼
          // TODO: 플로팅버튼 디자인, 위치 수정
          floatingActionButton: (!isSelecting)
              ? FloatingActionButton(
                  onPressed: () {
                    controller.enableSelectingLocation();
                  },
                  child: Icon(Icons.edit_location_alt),
                )
              : null, // 위치 선택중일 땐 플로팅버튼 비활성화
        ),
      );
    });
  }
}
