import 'package:flutter/material.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/controllers/stats_controller.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StatsController());

    return Scaffold(
      appBar: MindleTopAppBar(title: '통계', showBackButton: false),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '* 예시 페이지입니다.',
                style: MindleTextStyles.body3(color: MindleColors.errorRed),
              ),
              Text(
                '* 해당 통계는 정부 기관을 통한 실제 데이터가 아님을 알려드립니다.',
                style: MindleTextStyles.body3(color: MindleColors.errorRed),
              ),
              SizedBox(height: 20),
              // RegionTop5Section(),
              // SizedBox(height: 40),
              WordCloudSection(),
              SizedBox(height: 40),
              BarChartSection(),
              SizedBox(height: 40),
              PieChartSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class RegionTop5Section extends StatelessWidget {
  const RegionTop5Section({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('우리 동네 인기 민원 Top 5', style: MindleTextStyles.subtitle2()),
        Spacing.vertical20,
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.construction,
                size: 30,
                color: MindleColors.gray5,
              ),
              const SizedBox(height: 2),
              Text('준비중입니다.', style: MindleTextStyles.body5()),
            ],
          ),
        ),
      ],
    );
  }
}

class WordCloudSection extends StatelessWidget {
  const WordCloudSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('키워드 클라우드', style: MindleTextStyles.subtitle2()),
        Spacing.vertical8,
        SizedBox(
          height: 200,
          width: double.infinity * 0.8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Obx(
              () => CustomWordCloud(wordList: controller.wordCloudData.value),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomWordCloud extends StatelessWidget {
  final List<Map> wordList;

  CustomWordCloud({super.key, required this.wordList});

  final List<Color> _keywordCloudColors = [
    MindleColors.mainGreen,
    MindleColors.sudYellow,
    MindleColors.mainGreen.withOpacity(0.7),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(children: _buildPositionedWords(constraints)),
        );
      },
    );
  }

  List<Widget> _buildPositionedWords(BoxConstraints constraints) {
    final colors = _keywordCloudColors;

    List<Widget> positionedWords = [];
    List<Rect> occupiedRects = [];

    wordList.asMap().entries.forEach((entry) {
      final index = entry.key;
      final wordData = entry.value;
      final word = wordData['word'] as String;
      final value = wordData['value'] as int;
      final fontSize = _calculateFontSize(value);
      final color = colors[index % colors.length];

      final position = _findAvailablePosition(
        word,
        fontSize,
        constraints,
        occupiedRects,
      );

      final wordWidget = Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          word,
          style: MindleTextStyles.body1(
            color: color,
          ).copyWith(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      );

      positionedWords.add(
        Positioned(left: position.dx, top: position.dy, child: wordWidget),
      );

      occupiedRects.add(
        Rect.fromLTWH(
          position.dx,
          position.dy,
          _estimateTextWidth(word, fontSize) + 16,
          fontSize + 8,
        ),
      );
    });

    return positionedWords;
  }

  Offset _findAvailablePosition(
    String word,
    double fontSize,
    BoxConstraints constraints,
    List<Rect> occupiedRects,
  ) {
    final width = _estimateTextWidth(word, fontSize) + 16;
    final height = fontSize + 8;

    final center = Offset(
      constraints.maxWidth / 2 - width / 2,
      constraints.maxHeight / 2 - height / 2,
    );

    const double step = 6; // 이동 단위
    double angle = 0;
    double radius = 0;

    for (int i = 0; i < 500; i++) {
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      final newRect = Rect.fromLTWH(x, y, width, height);

      // ✅ 화면 벗어나면 무시
      if (x < 0 ||
          y < 0 ||
          x + width > constraints.maxWidth ||
          y + height > constraints.maxHeight) {
        angle += pi / 12;
        radius += step * 0.3;
        continue;
      }

      // ✅ 겹침 검사
      bool overlaps = occupiedRects.any((rect) => rect.overlaps(newRect));
      if (!overlaps) {
        return Offset(x, y);
      }

      // 나선 이동
      angle += pi / 12;
      radius += step * 0.3;
    }

    // fallback: 중앙
    return center;
  }

  double _estimateTextWidth(String text, double fontSize) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return painter.width; // 텍스트의 실제 너비 반환
  }

  double _calculateFontSize(int value) {
    final maxValue = wordList
        .map((e) => e['value'] as int)
        .reduce((a, b) => a > b ? a : b);
    final minValue = wordList
        .map((e) => e['value'] as int)
        .reduce((a, b) => a < b ? a : b);
    final normalizedValue = (value - minValue) / (maxValue - minValue);
    return 15 + (normalizedValue * 14); // 키워드 글자크기 배율!
  }
}

class BarChartSection extends StatelessWidget {
  const BarChartSection({super.key});

  static const double BAR_WIDTH = 25.0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('민원/처리 건수 현황', style: MindleTextStyles.subtitle2()),
        Spacing.vertical8,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Obx(
                  () => Stack(
                    children: [
                      BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceBetween,
                          maxY: 50,
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: 25,
                                color: MindleColors.gray6,
                                strokeWidth: 1,
                              ),
                            ],
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              top: BorderSide(color: MindleColors.gray6),
                              bottom: BorderSide(color: MindleColors.gray6),
                            ),
                          ),
                          barGroups: controller.barChartData1
                              .asMap()
                              .entries
                              .map((entry) {
                                int index = entry.key;
                                double value = entry.value;

                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: value,
                                      color: MindleColors.gray6,
                                      width: BAR_WIDTH,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ],
                                );
                              })
                              .toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: BAR_WIDTH / 2,
                        ),
                        child: LineChart(
                          LineChartData(
                            maxY: 50,
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: controller.barChartData2
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      int index = entry.key;
                                      double value = entry.value;
                                      return FlSpot(index.toDouble(), value);
                                    })
                                    .toList(),
                                color: MindleColors.mainGreen,
                                barWidth: 5,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 4,
                                          color: MindleColors.white,
                                          strokeWidth: 3,
                                          strokeColor: MindleColors.mainGreen,
                                        );
                                      },
                                ),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacing.vertical16,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: MindleColors.gray6,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Spacing.horizontal8,
                  Text('민원신청 건수', style: MindleTextStyles.body2()),
                  Spacing.horizontal20,
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: MindleColors.mainGreen,
                        width: 3, // 링 두께
                      ),
                    ),
                  ),
                  Spacing.horizontal8,
                  Text('처리완료 건수', style: MindleTextStyles.body2()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PieChartSection extends StatelessWidget {
  PieChartSection({super.key});

  final List<Color> _pieChartColors = [
    MindleColors.mainGreen,
    MindleColors.mainGreen.withOpacity(0.7),
    Color(0xFF0bb170),
    MindleColors.sudYellow.withOpacity(0.7),
    MindleColors.sudYellow,
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('11월 지역별 현황', style: MindleTextStyles.subtitle2()),
        Spacing.vertical8,
        Column(
          children: [
            SizedBox(
              height: 250,
              child: Obx(
                () => Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sections: controller.pieChartData.asMap().entries.map((
                          entry,
                        ) {
                          int index = entry.key;
                          int value = entry.value['value'];

                          return PieChartSectionData(
                            value: value.toDouble(),
                            color: _pieChartColors[index],
                            title: entry.value['word'],
                            radius: 50,
                            titleStyle: MindleTextStyles.body1().copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList(),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 55,
                        startDegreeOffset: 270,
                      ),
                    ),
                    // 🔹 중앙 텍스트 오버레이
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('최다민원신청', style: MindleTextStyles.body5()),
                        Text(
                          '${controller.pieChartData.first['word']}시',
                          style: MindleTextStyles.subtitle2(
                            color: MindleColors.errorRed,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${controller.pieChartData.first['value']}',
                          style: MindleTextStyles.body1().copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Spacing.vertical4,
            Obx(() {
              final data = controller.pieChartData;
              final half = (data.length / 2).ceil();

              final leftColumn = data.sublist(0, half);
              final rightColumn = data.sublist(half);

              Widget buildLegendItem(Map item, int index, Color color) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${item['word']}   ${item['value']}건",
                        style: MindleTextStyles.body2(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }

              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: leftColumn.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map item = entry.value;
                      return buildLegendItem(
                        item,
                        index,
                        _pieChartColors[index],
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 40),
                  Column(
                    children: rightColumn.asMap().entries.map((entry) {
                      int index = entry.key + half; // 색상 index 맞추기
                      Map item = entry.value;
                      return buildLegendItem(
                        item,
                        index,
                        _pieChartColors[index],
                      );
                    }).toList(),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }
}
