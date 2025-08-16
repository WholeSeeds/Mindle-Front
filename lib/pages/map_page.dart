import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/widgets/location_select_panel.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  static const Color gray7 = Color(0xFF474747);

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
          floatingActionButton: (!isSelecting)
              ? Padding(
                  padding: const EdgeInsets.only(
                    bottom: 50,
                    right: 5,
                  ), // 버튼 위치 조정
                  child: FloatingActionButton(
                    foregroundColor: Colors.white,
                    backgroundColor: gray7.withValues(alpha: 0.85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onPressed: () {
                      controller.enableSelectingLocation();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/write_icon.png',
                          width: 23,
                          height: 23,
                          color: Colors.white,
                        ),
                        Text(
                          '글쓰기',
                          style: TextStyle(fontSize: 9, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : null, // 위치 선택중일 땐 플로팅버튼 비활성화
        ),
      );
    });
  }
}
