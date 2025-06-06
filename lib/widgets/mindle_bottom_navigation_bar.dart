import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/bottom_nav_controller.dart';

class MindleBottomNavigationBar extends StatelessWidget {
  const MindleBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.getCurrentIndex(),
        onTap: controller.changeIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        ],
      ),
    );
  }
}
