import 'package:flutter/material.dart';
import 'package:mindle/designs.dart';

class PlaceMarkerLabel extends StatelessWidget {
  final String name;

  const PlaceMarkerLabel({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🔹 말풍선 본체
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: MindleColors.gray7,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: MindleTextStyles.body4(
              color: Colors.white,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        // 🔹 아래쪽 삼각형 (말풍선 꼬리)
        CustomPaint(
          size: const Size(16, 8),
          painter: _BalloonTailPainter(color: Colors.blueAccent),
        ),
      ],
    );
  }
}

class _BalloonTailPainter extends CustomPainter {
  final Color color;
  const _BalloonTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
