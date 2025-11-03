import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/complaint_list_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/models/category.dart';
import 'package:mindle/services/category_service.dart';
import 'package:mindle/widgets/mindle_textbutton.dart';

class CategorySelectButton extends StatelessWidget {
  const CategorySelectButton({super.key});

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
            return const _CategorySelectBottomSheet();
          },
        );
      },
      icon: SvgPicture.asset(
        'assets/icons/sliders-04.svg',
        width: 24,
        height: 24,
      ),
    );
  }
}

class _CategorySelectBottomSheet extends StatefulWidget {
  const _CategorySelectBottomSheet();

  @override
  State<_CategorySelectBottomSheet> createState() =>
      _CategorySelectBottomSheetState();
}

class _CategorySelectBottomSheetState
    extends State<_CategorySelectBottomSheet> {
  final CategoryService _categoryService = CategoryService();

  Category? selectedMainCategory; // 선택된 대분류
  Category? selectedSubCategory; // 선택된 소분류

  List<Category> mainCategories = []; // 대분류 목록
  List<Category> subCategories = []; // 소분류 목록

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _categoryService.getCategories();
      setState(() {
        mainCategories = categories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar('오류', '카테고리를 불러오는데 실패했습니다: $e');
    }
  }

  void _selectMainCategory(Category category) {
    setState(() {
      selectedMainCategory = category;
      selectedSubCategory = null;
      subCategories = category.children;
    });
  }

  void _selectSubCategory(Category category) {
    setState(() {
      selectedSubCategory = category;
    });
  }

  void _resetSelection() {
    setState(() {
      selectedMainCategory = null;
      selectedSubCategory = null;
      subCategories.clear();
    });
  }

  void _applySelection() {
    if (selectedMainCategory == null) {
      Get.snackbar('알림', '대분류를 선택해주세요.');
      return;
    }

    // controller에 필터 적용
    try {
      if (Get.isRegistered<ComplaintListController>()) {
        final complaintController = Get.find<ComplaintListController>();
        final categoryId = selectedSubCategory?.id ?? selectedMainCategory!.id;
        complaintController.setFilter(categoryId: categoryId);
      }
    } catch (e) {
      print('카테고리 필터 적용 오류: $e');
    }

    Get.back();

    // 선택 결과 표시
    String result = selectedMainCategory!.name;
    if (selectedSubCategory != null) {
      result += ' > ${selectedSubCategory!.name}';
    }

    // Get.snackbar('선택 완료', result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
              '카테고리',
              style: MindleTextStyles.subtitle2(
                color: MindleColors.black,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),

          // 본체
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // Left: 대분류 목록
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
                                    itemCount: mainCategories.length,
                                    itemBuilder: (context, index) {
                                      final category = mainCategories[index];
                                      final isSelected =
                                          selectedMainCategory?.id ==
                                          category.id;

                                      return InkWell(
                                        onTap: () =>
                                            _selectMainCategory(category),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          color: isSelected
                                              ? MindleColors.mainGreen
                                                    .withValues(alpha: 0.1)
                                              : null,
                                          child: Text(
                                            category.name,
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

                        // Right: 소분류 목록 (선택된 경우만)
                        if (subCategories.isNotEmpty)
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: subCategories.length,
                                    itemBuilder: (context, index) {
                                      final category = subCategories[index];
                                      final isSelected =
                                          selectedSubCategory?.id ==
                                          category.id;

                                      return InkWell(
                                        onTap: () =>
                                            _selectSubCategory(category),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          color: isSelected
                                              ? MindleColors.mainGreen
                                                    .withValues(alpha: 0.1)
                                              : null,
                                          child: Text(
                                            category.name,
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
                  onPressed: (selectedMainCategory != null)
                      ? _applySelection
                      : null,
                  textColor: (selectedMainCategory != null)
                      ? Colors.white
                      : MindleColors.gray5,
                  backgroundColor: (selectedMainCategory != null)
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
