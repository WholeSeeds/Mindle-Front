import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/bottom_nav_controller.dart';
import 'package:mindle/bottom_nav_items.dart';

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
        items: bottomNavItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
