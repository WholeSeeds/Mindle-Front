import 'package:get/get.dart';

class StatsController extends GetxController {
  final RxList<Map> wordCloudData = <Map>[
    {'word': '불법 주정차 신고', 'value': 100},
    {'word': '낙엽 미수거', 'value': 60},
    {'word': '가로등 파손', 'value': 55},
    {'word': '전기차 전용 주차', 'value': 50},
    {'word': '보도 블록 파손', 'value': 40},
    {'word': '공사장 소음', 'value': 35},
    {'word': '가로수 정리 요청', 'value': 31},
    {'word': '산책로 위험', 'value': 27},
    {'word': '도로 파임', 'value': 27},
  ].obs;

  final RxList<double> barChartData1 = <double>[
    45.0,
    34.0,
    35.0,
    30.0,
    40.0,
    20.0,
    30.0,
    23.0,
  ].obs;

  final RxList<double> barChartData2 = <double>[
    40.0,
    30.0,
    20.0,
    25.0,
    33.0,
    15.0,
    15.0,
    10.0,
  ].obs;

  final RxList<Map<String, dynamic>> pieChartData = <Map<String, dynamic>>[
    {'word': '수원', 'value': 3784},
    {'word': '용인', 'value': 3034},
    {'word': '화성', 'value': 2345},
    {'word': '성남', 'value': 1567},
    {'word': '고양', 'value': 1000},
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void refreshStatsData() {
    // TODO: 통계 가져오기 로직
  }

  void updateWordCloudData(List<Map> newData) {
    wordCloudData.value = newData;
  }

  void updateBarChartData1(List<double> newData) {
    barChartData1.value = newData;
  }

  void updateBarChartData2(List<double> newData) {
    barChartData2.value = newData;
  }

  void updatePieChartData(List<Map<String, dynamic>> newData) {
    pieChartData.value = newData;
  }
}
