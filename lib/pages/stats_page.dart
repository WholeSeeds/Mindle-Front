import 'package:flutter/material.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';
import 'package:mindle/designs.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MindleTopAppBar(title: '통계', showBackButton: false),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction, size: 50, color: MindleColors.gray5),
            Spacing.vertical8,
            Text('서비스 준비중입니다.', style: MindleTextStyles.body2()),
          ],
        ),
      ),
    );
  }
}
