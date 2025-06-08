import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        onMapReady: (controller) {
          print("네이버맵 로딩완료");
        },
      ),
    );
  }
}
