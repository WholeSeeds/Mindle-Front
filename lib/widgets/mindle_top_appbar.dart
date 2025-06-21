import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MindleTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MindleTopAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      title: Text(title),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
