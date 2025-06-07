import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TmpPage extends StatelessWidget {
  const TmpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('임시페이지'),
            TextButton(onPressed: () => Get.back(), child: const Text('뒤로')),
          ],
        ),
      ),
    );
  }
}
