import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/bottom_nav_controller.dart';

class MindleBottomNavigationBar extends StatelessWidget {
  final BottomNavController controller;

  const MindleBottomNavigationBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: '통계'),
          BottomNavigationBarItem(icon: Icon(Icons.back_hand), label: '민원작성'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '민원목록'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        ],
      ),
    );
  }
}
