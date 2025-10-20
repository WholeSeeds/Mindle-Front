import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/bottom_nav_controller.dart';
import 'package:mindle/bottom_nav_items.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/pages/stt_page.dart';

class MindleBottomNavigationBar extends StatelessWidget {
  final BottomNavController controller;
  final int centerIndex;

  const MindleBottomNavigationBar({
    super.key,
    required this.controller,
    this.centerIndex = 2,
  });

  @override
  Widget build(BuildContext context) {
    final tabCount = bottomNavItems.length;
    final tabWidth = MediaQuery.of(context).size.width / tabCount;

    return Obx(
      () => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 77,
            decoration: BoxDecoration(
              color: MindleColors.gray3,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 25,
                  spreadRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
          ),

          // 아이콘 + 라벨
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(tabCount, (index) {
                final item = bottomNavItems[index];
                final isSelected = controller.currentIndex.value == index;
                final isCenter = index == centerIndex;

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => controller.changeIndex(index),
                  onLongPress: () {
                    // 민원작성 버튼(centerIndex)을 길게 누르면 STT 페이지로 이동
                    if (index == centerIndex) {
                      print('✅ 민원작성 버튼 길게 누름 - STT 페이지로 이동!');
                      Get.to(() => const SttPage());
                    }
                  },
                  child: SizedBox(
                    width: tabWidth,
                    height: 90,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // 라벨
                        Positioned(
                          bottom: 15,
                          child: Text(
                            item.label,
                            style: MindleTextStyles.body5(
                              color: isSelected
                                  ? MindleColors.mainGreen
                                  : MindleColors.gray8,
                            ),
                          ),
                        ),

                        // 아이콘
                        if (isCenter)
                          Positioned(
                            top: -35, // 튀어나오게
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // 바깥 원 (하단바 색)
                                Container(
                                  width: 77,
                                  height: 77,
                                  decoration: BoxDecoration(
                                    color: MindleColors.gray3,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                // 내부 원 (선택 색상)
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? MindleColors.mainGreen
                                        : MindleColors.gray8,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: isSelected
                                        ? item.activeIconBuilder(context)
                                        : item.inactiveIconBuilder(context),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          // 일반 아이콘
                          Positioned(
                            top: 15,
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: isSelected
                                  ? item.activeIconBuilder(context)
                                  : item.inactiveIconBuilder(context),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
