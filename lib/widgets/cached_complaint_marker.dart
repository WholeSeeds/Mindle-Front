import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/services/svg_cache_service.dart';

/// CustomPainter를 사용해 캐시된 Picture로 민원 마커를 그리는 위젯
/// 비동기 로딩 문제 없이 즉시 렌더링 가능
class CachedComplaintMarker extends StatelessWidget {
  final int complaintCount;
  final double size;

  const CachedComplaintMarker({
    super.key,
    required this.complaintCount,
    this.size = 70,
  });

  int get level {
    if (complaintCount < 2) return 0;
    if (complaintCount < 5) return 1;
    return 2;
  }

  String get iconPath {
    return switch (level) {
      0 => 'assets/icons/complaint-cold.svg',
      1 => 'assets/icons/complaint-middle.svg',
      _ => 'assets/icons/complaint-hot.svg',
    };
  }

  Color get levelColor {
    const colorList = [
      MindleColors.gray8,
      MindleColors.attentionYellow2,
      MindleColors.errorRed,
    ];
    return colorList[level];
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: ComplaintMarkerPainter(
        iconPath: iconPath,
        complaintCount: complaintCount,
        levelColor: levelColor,
        markerSize: size,
      ),
    );
  }
}

/// 민원 마커를 그리는 CustomPainter
class ComplaintMarkerPainter extends CustomPainter {
  final String iconPath;
  final int complaintCount;
  final Color levelColor;
  final double markerSize;
  final SvgCacheService _svgCache = SvgCacheService();

  ComplaintMarkerPainter({
    required this.iconPath,
    required this.complaintCount,
    required this.levelColor,
    required this.markerSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 그림자 아이콘 그리기
    final shadowPicture = _svgCache.getCachedPicture(
      iconPath,
      width: markerSize,
      height: markerSize,
      color: MindleColors.gray5,
    );
    
    if (shadowPicture != null) {
      canvas.save();
      canvas.translate(1, 1); // 그림자 오프셋
      canvas.drawPicture(shadowPicture);
      canvas.restore();
    }

    // 메인 아이콘 그리기
    final mainPicture = _svgCache.getCachedPicture(
      iconPath,
      width: markerSize,
      height: markerSize,
    );
    
    if (mainPicture != null) {
      canvas.drawPicture(mainPicture);
    }

    // 카운트 뱃지 그리기
    _drawCountBadge(canvas, size);
  }

  void _drawCountBadge(Canvas canvas, Size size) {
    const badgeSize = 20.0;
    const badgeRadius = badgeSize / 2;
    
    // 뱃지 위치 계산 (우상단)
    final badgeCenter = Offset(
      size.width - 3 - badgeRadius,
      -2 + badgeRadius + 3, // CONTAINER_PADDING 고려
    );

    // 뱃지 배경 그리기
    final badgePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(badgeCenter, badgeRadius, badgePaint);

    // 뱃지 테두리 그리기
    final borderPaint = Paint()
      ..color = levelColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    canvas.drawCircle(badgeCenter, badgeRadius, borderPaint);

    // 텍스트 그리기
    final textPainter = TextPainter(
      text: TextSpan(
        text: complaintCount.toString(),
        style: TextStyle(
          color: levelColor,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    final textOffset = Offset(
      badgeCenter.dx - textPainter.width / 2,
      badgeCenter.dy - textPainter.height / 2,
    );
    
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(ComplaintMarkerPainter oldDelegate) {
    return oldDelegate.iconPath != iconPath ||
           oldDelegate.complaintCount != complaintCount ||
           oldDelegate.levelColor != levelColor ||
           oldDelegate.markerSize != markerSize;
  }
}