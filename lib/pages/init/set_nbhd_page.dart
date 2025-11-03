import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/nbhd_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/widgets/icon_textbox.dart';
import 'package:mindle/widgets/mindle_textbutton.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';

// 동네 설정 페이지
class SetNbhdPage extends StatelessWidget {
  final controller = Get.find<NbhdController>();

  SetNbhdPage({super.key});

  void _showNeighborhoodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NeighborhoodBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MindleTopAppBar(title: '동네 설정'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.vertical30,
            Text('거주하고 계신 동네를\n선택해주세요', style: MindleTextStyles.headline1()),
            Spacing.vertical8,
            Text(
              '현재 거주하시는 동네를 선택해주세요',
              style: MindleTextStyles.body1(color: MindleColors.gray1),
            ),
            Spacing.vertical30,
            const SizedBox(height: 16),

            const IconTextBox(
              text: '경기도',
              textColor: MindleColors.mainGreen,
              borderColor: MindleColors.gray6,
            ),
            Spacing.vertical12,

            Obx(() {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: MindleColors.gray6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => _showNeighborhoodBottomSheet(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.selectedFirst.value.isNotEmpty
                              ? '${controller.selectedFirst.value} ${controller.selectedSecond.value} ${controller.selectedThird.value}'
                              : '지역을 선택하세요',
                          style: MindleTextStyles.body1(
                            color: controller.selectedFirst.value.isNotEmpty
                                ? MindleColors.mainGreen
                                : MindleColors.gray8,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_sharp,
                          color: MindleColors.gray5,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            Obx(
              () => SizedBox(
                width: double.infinity,
                child: MindleTextButton(
                  label: '수정 완료',
                  onPressed: controller.selectedThird.value.isNotEmpty
                      ? () async {
                          bool success = await controller.setNeighborhood();
                          Get.offNamed('/'); // SetNbhdPage 닫기
                        }
                      : null,
                  textColor: (controller.selectedThird.value.isNotEmpty)
                      ? MindleColors.white
                      : MindleColors.gray5,
                  backgroundColor: (controller.selectedThird.value.isNotEmpty)
                      ? MindleColors.mainGreen
                      : MindleColors.gray4,
                ),
              ),
            ),
            Spacing.vertical20,
            Spacing.vertical20,
          ],
        ),
      ),
    );
  }
}

// ============================
//   동네 선택 Bottom Sheet
// ============================

class NeighborhoodBottomSheet extends StatefulWidget {
  const NeighborhoodBottomSheet({super.key});

  @override
  State<NeighborhoodBottomSheet> createState() =>
      _NeighborhoodBottomSheetState();
}

class _NeighborhoodBottomSheetState extends State<NeighborhoodBottomSheet> {
  final controller = Get.find<NbhdController>();
  String? selectedLeft; // 1depth + 2depth 조합
  String? selectedRight; // 3depth
  List<String> leftOptions = [];
  List<String> rightOptions = [];

  @override
  void initState() {
    super.initState();
    _buildLeftOptions();
  }

  void _buildLeftOptions() {
    leftOptions.clear();

    if (controller.addressData != null &&
        controller.addressData!['경기도'] != null) {
      final gyeonggiData = controller.addressData!['경기도'];

      for (String city in gyeonggiData.keys) {
        final cityData = gyeonggiData[city];

        if (cityData is List) {
          // 2depth가 없는 경우: 1depth와 3depth를 모두 좌측에
          for (String dong in cityData) {
            leftOptions.add('$city $dong');
          }
        } else if (cityData is Map) {
          // 2depth가 있는 경우: 1depth + 2depth를 좌측에
          for (String district in cityData.keys) {
            leftOptions.add('$city $district');
          }
        }
      }
    }
  }

  void _onLeftSelected(String option) {
    setState(() {
      selectedLeft = option;
      selectedRight = null;
      _buildRightOptions(option);
    });
  }

  void _buildRightOptions(String leftOption) {
    rightOptions.clear();

    final parts = leftOption.split(' ');
    if (parts.length >= 2) {
      final city = parts[0];
      final district = parts[1];

      final cityData = controller.addressData!['경기도'][city];
      if (cityData is Map && cityData[district] is List) {
        rightOptions = List<String>.from(cityData[district]);
      }
    }
  }

  void _onConfirm() {
    if (selectedLeft != null) {
      final parts = selectedLeft!.split(' ');
      if (parts.length >= 2) {
        final city = parts[0];
        final secondPart = parts[1];

        // 원본 데이터에서 해당 도시의 데이터 구조 확인
        final cityData = controller.addressData!['경기도'][city];

        if (cityData is List) {
          // 2depth가 없는 경우: parts[1]이 3depth(동)
          controller.selectFirst(city);
          controller.selectSecond(''); // 2depth 없음
          controller.selectThird(secondPart);
        } else if (cityData is Map) {
          // 2depth가 있는 경우: parts[1]이 2depth(구/읍/면)
          controller.selectFirst(city);
          controller.selectSecond(secondPart);
          controller.selectThird(selectedRight ?? '');
        }
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '동네 설정',
              style: MindleTextStyles.subtitle2(
                color: MindleColors.black,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),

          // 본체
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // 좌측 영역
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: MindleColors.gray6,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: leftOptions.length,
                              itemBuilder: (context, index) {
                                final option = leftOptions[index];
                                final isSelected = selectedLeft == option;

                                return InkWell(
                                  onTap: () => _onLeftSelected(option),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    color: isSelected
                                        ? MindleColors.mainGreen.withValues(
                                            alpha: 0.1,
                                          )
                                        : null,
                                    child: Text(
                                      option,
                                      style: MindleTextStyles.body2(
                                        color: isSelected
                                            ? MindleColors.mainGreen
                                            : MindleColors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 우측 영역 (3depth가 있는 경우만)
                  rightOptions.isNotEmpty
                      ? Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: rightOptions.length,
                                  itemBuilder: (context, index) {
                                    final option = rightOptions[index];
                                    final isSelected = selectedRight == option;

                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedRight = option;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        color: isSelected
                                            ? MindleColors.mainGreen.withValues(
                                                alpha: 0.1,
                                              )
                                            : null,
                                        child: Text(
                                          option,
                                          style: MindleTextStyles.body2(
                                            color: isSelected
                                                ? MindleColors.mainGreen
                                                : MindleColors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),

          // 하단 버튼
          Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MindleTextButton(
                  label: '취소',
                  onPressed: () => Navigator.pop(context),
                  textColor: MindleColors.gray1,
                  backgroundColor: MindleColors.white,
                  fontWeight: FontWeight.w600,
                  hasBorder: true,
                ),
                Spacing.horizontal16,
                MindleTextButton(
                  label: '확인',
                  onPressed: selectedLeft != null ? _onConfirm : null,
                  textColor: selectedLeft != null
                      ? Colors.white
                      : MindleColors.gray5,
                  backgroundColor: selectedLeft != null
                      ? MindleColors.mainGreen
                      : MindleColors.gray4,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
