import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mindle/controllers/complaint_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/models/public_place.dart';
import 'package:get/get.dart';
import 'package:mindle/models/region_info.dart';
import 'package:mindle/widgets/icon_textbox.dart';
import 'package:mindle/widgets/mindle_dropdown.dart';
import 'package:mindle/widgets/mindle_textbutton.dart';
import 'package:mindle/widgets/mindle_textfield.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';

class ComplaintFormPage extends StatelessWidget {
  final PublicPlace? place;
  final RegionInfo? regionInfo;

  static const Color mainGreen = Color(0xFF00D482);
  static const Color gray4 = Color(0xFFF1F3F5);
  static const Color gray5 = Color(0xFFBEBEBE);
  static const Color gray6 = Color(0xFFEDEDED);

  ComplaintFormPage({super.key, required this.place, required this.regionInfo});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ComplaintController());
    return Scaffold(
      appBar: MindleTopAppBar(title: "민원 작성"),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔴 부적절한 단어 경고 말풍선
            Obx(() {
              final hasWarning =
                  controller.titleProfanityWarning.value.isNotEmpty ||
                  controller.contentProfanityWarning.value.isNotEmpty;
              if (!hasWarning) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  '부적절한 단어가 포함되어있어요!',
                  style: MindleTextStyles.body4(
                    color: MindleColors.black,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              );
            }),

            // ✅ 민원 보내기 버튼
            Obx(
              () => SizedBox(
                width: double.infinity, // 💡 좌우 꽉 채우기
                child: MindleTextButton(
                  label: '민원 보내기',
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    try {
                      print('민원 제출 시작');
                      final isSuccess = await controller.submitComplaint(
                        place: place,
                        regionInfo: regionInfo,
                      );
                      print('isSuccess: $isSuccess');
                      if (isSuccess) {
                        print('화면 닫기 시도');
                        if (navigator.canPop()) {
                          print('Navigator에서 pop 가능 - Navigator.pop() 사용');
                          navigator.pop();
                          print('Navigator.pop() 완료');
                        } else {
                          print('Navigator에서 pop 불가능');
                        }
                      } else {
                        print('민원 제출 실패 - isSuccess가 false');
                      }
                      print('민원 제출 완료');
                    } catch (e) {
                      print('민원 제출 중 오류: $e');
                      Get.snackbar('오류', '민원 제출 중 오류가 발생했습니다.');
                    }
                  },
                  textColor:
                      (controller.selectedMainCategory.value == null ||
                          controller.title.value.isEmpty ||
                          controller.content.value.isEmpty ||
                          controller.titleProfanityWarning.value.isNotEmpty ||
                          controller.contentProfanityWarning.value.isNotEmpty)
                      ? gray5
                      : Colors.white,
                  backgroundColor:
                      (controller.selectedMainCategory.value == null ||
                          controller.title.value.isEmpty ||
                          controller.content.value.isEmpty ||
                          controller.titleProfanityWarning.value.isNotEmpty ||
                          controller.contentProfanityWarning.value.isNotEmpty)
                      ? gray4
                      : mainGreen,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 위치 정보 표시
                  (place != null)
                      ? IconTextBox(text: place!.name, icon: Icons.place)
                      : (regionInfo != null)
                      ? IconTextBox(
                          text: regionInfo!.fullAddressString(),
                          icon: Icons.place,
                        )
                      : IconTextBox(
                          text: '위치 입력',
                          icon: Icons.place,
                          iconColor: gray5,
                          textColor: gray5,
                          borderColor: gray6,
                        ),
                  Spacing.vertical16,
                  // 메인 카테고리 선택
                  Obx(
                    () => MindleDropdown<String>(
                      hint: '대분류 선택',
                      value: controller.selectedMainCategory.value?.name,
                      items: controller.categories
                          .map(
                            (category) => MindleDropdownItem(
                              value: category.name,
                              label: category.name,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        final selectedCategory = controller.categories
                            .firstWhere((cat) => cat.name == value);
                        controller.selectMainCategory(selectedCategory);
                      },
                    ),
                  ),
                  Spacing.vertical16,
                  // 서브 카테고리 선택
                  Obx(
                    () =>
                        controller.selectedMainCategory.value != null &&
                            controller
                                .selectedMainCategory
                                .value!
                                .children
                                .isNotEmpty
                        ? Column(
                            children: [
                              MindleDropdown<String>(
                                hint: '세부분류 선택',
                                value:
                                    controller.selectedSubCategory.value?.name,
                                items: controller
                                    .selectedMainCategory
                                    .value!
                                    .children
                                    .map(
                                      (subCategory) => MindleDropdownItem(
                                        value: subCategory.name,
                                        label: subCategory.name,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  final selectedSubCategory = controller
                                      .selectedMainCategory
                                      .value!
                                      .children
                                      .firstWhere((sub) => sub.name == value);
                                  controller.selectSubCategory(
                                    selectedSubCategory,
                                  );
                                },
                              ),
                              Spacing.vertical16,
                            ],
                          )
                        : Container(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MindleTextField(
                        hint: '제목을 입력해주세요',
                        onChanged: (v) => controller.updateTitle(v),
                      ),
                      // Obx(
                      //   () => controller.titleProfanityWarning.value.isNotEmpty
                      //       ? Padding(
                      //           padding: const EdgeInsets.only(top: 4.0),
                      //           child: Text(
                      //             controller.titleProfanityWarning.value,
                      //             style: const TextStyle(
                      //               color: Colors.red,
                      //               fontSize: 12,
                      //             ),
                      //           ),
                      //         )
                      //       : Container(),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MindleTextField(
                        hint: '어떤 점이 불편하셨나요?',
                        maxLines: 5,
                        maxLength: 200,
                        onChanged: (v) => controller.updateContent(v),
                      ),
                      // Obx(
                      //   () =>
                      //       controller.contentProfanityWarning.value.isNotEmpty
                      //       ? Padding(
                      //           padding: const EdgeInsets.only(top: 4.0),
                      //           child: Text(
                      //             controller.contentProfanityWarning.value,
                      //             style: const TextStyle(
                      //               color: Colors.red,
                      //               fontSize: 12,
                      //             ),
                      //           ),
                      //         )
                      //       : Container(),
                      // ),
                    ],
                  ),
                  Spacing.vertical20,

                  // 이미지 업로드 영역
                  SizedBox(
                    // ListView를 SizeBox로 감싸서 사이즈를 강제로 지정해야 함,
                    height: 200, // 이미지 업로드 영역의 높이 설정
                    child: Obx(() {
                      final imgs = controller.images;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ...imgs.map(
                            (img) => Stack(
                              children: [
                                Image.file(
                                  File(img!.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        controller.images.remove(img),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (imgs.length < 3) // 최대 3개 이미지 업로드 가능
                            IconButton(
                              icon: const Icon(Icons.add_a_photo),
                              onPressed: () {
                                _showPickOptions(context, controller);
                              },
                            ),
                        ],
                      );
                    }),
                  ),
                  Spacing.vertical20,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showPickOptions(BuildContext context, ComplaintController controller) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('카메라로 촬영'),
            onTap: () {
              controller.pickImageFromCamera();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('갤러리에서 선택'),
            onTap: () {
              controller.pickImagesFromGallery();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
