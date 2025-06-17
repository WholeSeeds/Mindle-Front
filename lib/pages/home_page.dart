import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('홈'),
            TextButton(
              onPressed: () => Get.toNamed('/inside'),
              child: const Text('다음 페이지'),
            ),
          ],
        ),
      ),
    );
  }
}
