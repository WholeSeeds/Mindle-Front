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
      body: NaverMap(
        onMapReady: (naverMapController) {
          print("네이버맵 준비 완료");
          controller.setMapController(naverMapController);
        },
      ),
    );
  }
}
