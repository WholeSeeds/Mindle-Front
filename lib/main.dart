import 'package:flutter/material.dart';
import 'package:mindle/controllers/bottom_nav_controller.dart';
import 'package:mindle/pages.dart';
import 'package:mindle/pages/home_page.dart';
import 'package:mindle/pages/profile_page.dart';
import 'package:mindle/widgets/mindle_bottom_navigation_bar.dart';
import 'package:get/get.dart';

void main() {
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

  final List<Widget> pages = const [HomePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return Obx(
      () => Scaffold(
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: MindleBottomNavigationBar(controller: controller),
      ),
    );
  }
}
