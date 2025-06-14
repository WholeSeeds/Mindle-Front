import 'package:flutter/material.dart';
import 'package:mindle/controllers/bottom_nav_controller.dart';
import 'package:mindle/controllers/nbhd_controller.dart';
import 'package:mindle/bottom_nav_items.dart';
import 'package:mindle/route_pages.dart';
import 'package:mindle/widgets/mindle_bottom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // .env 파일 로드
  await dotenv.load();

  Get.put(BottomNavController());
  Get.put(NbhdController());
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
      initialRoute: "/init",
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
