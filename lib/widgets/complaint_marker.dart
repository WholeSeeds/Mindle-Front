import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindle/designs.dart';

class ComplaintMarker extends StatelessWidget {
  final int complaintCount;

  const ComplaintMarker({super.key, required this.complaintCount});

  int get level {
    if (complaintCount < 2) return 0;
    if (complaintCount < 5) return 1;
    return 2;
  }

  static const CONTAINER_PADDING = 3.0;

  @override
  Widget build(BuildContext context) {
    final colorList = [
      MindleColors.gray8,
      MindleColors.attentionYellow2,
      MindleColors.errorRed,
    ];

    final iconPath = switch (level) {
      0 => 'assets/icons/complaint-cold.svg',
      1 => 'assets/icons/complaint-middle.svg',
      _ => 'assets/icons/complaint-hot.svg',
    };

    return Container(
      padding: const EdgeInsets.only(top: CONTAINER_PADDING), // 위쪽 여유 공간
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 1,
            child: SvgPicture.asset(
              iconPath,
              width: 70,
              height: 70,
              color: MindleColors.gray5,
            ),
          ),
          SvgPicture.asset(iconPath, width: 70, height: 70),

          if (level != 0)
            Positioned(
              right: 3,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorList[level], width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  complaintCount.toString(),
                  style: TextStyle(
                    color: colorList[level],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
