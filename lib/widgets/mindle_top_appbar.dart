import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MindleTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Widget? customLeading;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;

  const MindleTopAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.customLeading,
    this.actions,
    this.onBackPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      shadowColor: Colors.transparent,
      titleTextStyle: Theme.of(context).textTheme.headlineSmall,
      automaticallyImplyLeading: false,
      leading: _buildLeading(),
      title: Text(title),
      centerTitle: true,
      actions: actions,
    );
  }

  Widget? _buildLeading() {
    // 좌측 아이콘
    if (customLeading != null) {
      return customLeading;
    }

    if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Get.back(),
      );
    }

    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
