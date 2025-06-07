import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('민원작성'),
            TextButton(
              onPressed: () => Get.toNamed('/tmp'),
              child: const Text('다음 페이지'),
            ),
          ],
        ),
      ),
    );
  }
}
