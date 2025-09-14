import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/bottom_nav_controller.dart';
import 'package:mindle/bottom_nav_items.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:mindle/designs.dart';

class MindleBottomNavigationBar extends StatelessWidget {
  final BottomNavController controller;

  const MindleBottomNavigationBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: MindleColors.gray3,
        activeColor: MindleColors.mainGreen,
        color: MindleColors.gray8,
        height: 80,
        top: -75,
        curveSize: -100,
        cornerRadius: 20,
        shadowColor: MindleColors.gray5,
        elevation: 10,
        initialActiveIndex: controller.currentIndex.value,
        onTap: controller.changeIndex,
        items: List.generate(bottomNavItems.length, (index) {
          final item = bottomNavItems[index];
          final isSelected = controller.currentIndex.value == index;
          return TabItem(
            icon: isSelected ? item.activeIcon : item.inactiveIcon,
            title: item.label,
          );
        }),
      ),
    );
  }
}
