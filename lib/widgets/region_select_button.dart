import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/complaint_list_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/widgets/mindle_textbutton.dart';

class RegionSelectButton extends StatelessWidget {
  const RegionSelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      visualDensity: VisualDensity.compact,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return const _RegionSelectBottomSheet();
          },
        );
      },
      icon: SvgPicture.asset(
        'assets/icons/marker-pin-01.svg',
        width: 24,
        height: 24,
      ),
    );
  }
}

class _RegionSelectBottomSheet extends StatefulWidget {
  const _RegionSelectBottomSheet();

  @override
  State<_RegionSelectBottomSheet> createState() =>
      _RegionSelectBottomSheetState();
}

class _RegionSelectBottomSheetState extends State<_RegionSelectBottomSheet> {
  final ComplaintListController controller =
      Get.find<ComplaintListController>();

  String selectedCity = ''; // 선택된 시/군
  String selectedDistrict = ''; // 선택된 구/읍/면

  @override
  void initState() {
    super.initState();
    // 현재 선택된 값으로 초기화
    selectedCity = controller.selectedCityName.value;
    selectedDistrict = controller.selectedDistrictName.value;
  }

  void _selectCity(String cityName) {
    setState(() {
      selectedCity = cityName;
      selectedDistrict = ''; // 시/군 변경시 구/읍/면 초기화
    });

    // 컨트롤러에 시/군 선택 알림
    controller.selectCity(cityName);
  }

  void _selectDistrict(String districtName) {
    setState(() {
      selectedDistrict = districtName;
    });

    // 컨트롤러에 구/읍/면 선택 알림
    controller.selectDistrict(districtName);
  }

  void _resetSelection() {
    setState(() {
      selectedCity = '';
      selectedDistrict = '';
    });
    controller.selectedCityName.value = '';
    controller.selectedDistrictName.value = '';
    controller.districtList.clear();
  }

  bool _isSelectionValid() {
    if (selectedCity.isEmpty) return false;

    // districtList가 비어있으면 city만 선택해도 OK
    if (controller.districtList.isEmpty) return true;

    // districtList가 있으면 district도 선택해야 함
    return selectedDistrict.isNotEmpty;
  }

  void _applySelection() async {
    if (!_isSelectionValid()) {
      Get.snackbar('알림', '지역을 올바르게 선택해주세요.');
      return;
    }

    // ComplaintListController에 필터 적용
    try {
      await controller.setFilterByRegionSelection();
      Get.back();

      // 선택 결과 표시
      String result = selectedCity;
      if (selectedDistrict.isNotEmpty) {
        result += ' > $selectedDistrict';
      }
      // Get.snackbar('선택 완료', result);
    } catch (e) {
      print('지역 필터 적용 오류: $e');
      Get.snackbar('오류', '지역 필터 적용에 실패했습니다.');
    }
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
              '지역 필터',
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
                  // Left: 시/군 목록
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
                            child: Obx(
                              () => ListView.builder(
                                itemCount: controller.cityList.length,
                                itemBuilder: (context, index) {
                                  final city = controller.cityList[index];
                                  final isSelected = selectedCity == city;

                                  return InkWell(
                                    onTap: () => _selectCity(city),
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
                                        city,
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
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right: 구/읍/면 목록 (있는 경우만)
                  Obx(() {
                    if (controller.districtList.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.districtList.length,
                              itemBuilder: (context, index) {
                                final district = controller.districtList[index];
                                final isSelected = selectedDistrict == district;

                                return InkWell(
                                  onTap: () => _selectDistrict(district),
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
                                      district,
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
                    );
                  }),
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
                  onPressed: () {
                    _resetSelection();
                    Navigator.pop(context);
                  },
                  textColor: MindleColors.gray1,
                  backgroundColor: MindleColors.white,
                  fontWeight: FontWeight.w600,
                  hasBorder: true,
                ),
                Spacing.horizontal16,
                MindleTextButton(
                  label: '확인',
                  onPressed: _isSelectionValid() ? _applySelection : null,
                  textColor: _isSelectionValid()
                      ? Colors.white
                      : MindleColors.gray5,
                  backgroundColor: _isSelectionValid()
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
