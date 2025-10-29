import 'package:flutter/material.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/pages/complaint_form_page.dart';
import 'package:mindle/pages/stt_page.dart';
import 'package:get/get.dart';
import 'package:mindle/widgets/icon_textbox.dart';
import 'package:mindle/widgets/mindle_dialog.dart';
import 'package:mindle/widgets/mindle_textbutton.dart';

class LocationSelectPanel extends StatelessWidget {
  LocationSelectPanel({super.key});

  final controller = Get.find<LocationController>();

  static const Color gray5 = Color(0xFFBEBEBE);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 내용
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.vertical8,
              const Text(
                '첨부할 위치를 선택해주세요',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Spacing.vertical4,
              const Text(
                '? 공공기관이 없어요',
                style: TextStyle(fontSize: 10, color: Colors.blue),
              ),
              Spacing.vertical16,
              const Text(
                '선택된 위치',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),

              Spacing.vertical4,
              // 선택된 위치 정보
              Obx(
                () => Stack(
                  children: [
                    IconTextBox(text: controller.selectedLocationString.value),

                    // 선택된 위치가 있을 때만 삭제 버튼 표시
                    if (controller.selectedLocationString.value != '')
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 20, color: gray5),
                          onPressed: () {
                            controller.initSelectedLocation();
                          },
                        ),
                      ),
                  ],
                ),
              ),

              Spacing.vertical20,
            ],
          ),
        ),

        // 민원 작성 버튼
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: SizedBox(
            width: double.infinity,
            child: Obx(
              () => MindleTextButton(
                label: (controller.selectedLocationString.value == '')
                    ? '건너뛰기'
                    : '다음',

                onPressed: () {
                  print('✅ 버튼 클릭 - 민원 작성 페이지로 이동!');
                  print(
                    '   선택된 장소: ${controller.selectedPlace.value?.name}, 선택된 지역 정보: ${controller.selectedRegionInfo.value}',
                  );
                  if (controller.selectedPlace.value == null &&
                      controller.selectedRegionInfo.value == null) {
                    // 위치 선택 안 했을 때 경고창 표시
                    showDialog(
                      context: context,
                      builder: (_) => MindleDialog(
                        title: '위치 건너뛰기',
                        content: '위치를 선택하지 않고 글을 작성할까요?',
                        firstButton: '확인',
                        firstButtonAction: () {
                          Get.to(
                            () => ComplaintFormPage(
                              place: controller.selectedPlace.value,
                              regionInfo: controller.selectedRegionInfo.value,
                            ),
                          );
                        },
                        secondButton: '취소',
                        secondButtonAction: () {
                          // 취소 시 아무것도 안 함
                        },
                      ),
                    );
                    return;
                  }

                  // 정상적으로 선택했을 때 바로 이동
                  Get.to(
                    () => ComplaintFormPage(
                      place: controller.selectedPlace.value,
                      regionInfo: controller.selectedRegionInfo.value,
                    ),
                  );
                },
                onLongPress: () {
                  // 길게 누르면 STT 페이지로 이동
                  print('✅ 버튼 길게 누름 - STT 페이지로 이동!');
                  Get.to(() => const SttPage());
                },
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
