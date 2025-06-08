import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:mindle/controllers/bottom_nav_controller.dart';
import 'package:mindle/bottom_nav_items.dart';
import 'package:mindle/route_pages.dart';
import 'package:mindle/widgets/mindle_bottom_navigation_bar.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // 네이버 지도 초기화: client Id를 지정
  await FlutterNaverMap().init(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID'] ?? '',
    onAuthFailed: (ex) => switch (ex) {
      NQuotaExceededException(:final message) => print(
        "사용량 초과 (message: $message)",
      ),
      NUnauthorizedClientException() ||
      NClientUnspecifiedException() ||
      NAnotherAuthFailedException() => print("인증 실패: $ex"),
    },
  );

  Get.put(BottomNavController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WholeSeeds',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // initialRoute는 명시하지 않으면 자동으로 '/'로 지정됨
      getPages: allPages,
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return Obx(
      () => Scaffold(
        body: bottomNavItems[controller.currentIndex.value].page,
        bottomNavigationBar: MindleBottomNavigationBar(controller: controller),
      ),
    );
  }
}
