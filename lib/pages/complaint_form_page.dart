import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mindle/controllers/complaint_controller.dart';
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
    final controller = Get.find<ComplaintController>();
    return Scaffold(
      appBar: MindleTopAppBar(title: "민원 작성"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
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
                  const SizedBox(height: 15),
                  Obx(
                    () => MindleDropdown<String>(
                      hint: '카테고리 선택',
                      value: controller.selectedCategory.value,
                      items: controller.categoryList
                          .map((e) => MindleDropdownItem(value: e, label: e))
                          .toList(),
                      onChanged: (v) => controller.selectedCategory.value = v,
                    ),
                  ),
                  const SizedBox(height: 15),
                  MindleTextField(
                    hint: '제목을 입력해주세요',
                    onChanged: (v) => controller.title.value = v,
                  ),
                  const SizedBox(height: 10),
                  MindleTextField(
                    hint: '어떤 점이 불편하셨나요?',
                    maxLines: 5,
                    maxLength: 200,
                    onChanged: (v) => controller.content.value = v,
                  ),
                  const SizedBox(height: 20),

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
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Obx(
                () => MindleTextButton(
                  label: '민원 보내기',
                  onPressed: () => controller.submitComplaint(
                    place: place,
                    regionInfo: regionInfo,
                  ), // 둘 중 하나, 혹은 둘 다 null인 상태로 submit됨
                  textColor:
                      (controller.selectedCategory.value == null ||
                          controller.title.value.isEmpty ||
                          controller.content.value.isEmpty)
                      ? gray5
                      : Colors.white,
                  backgroundColor:
                      (controller.selectedCategory.value == null ||
                          controller.title.value.isEmpty ||
                          controller.content.value.isEmpty)
                      ? gray4
                      : mainGreen,
                ),
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
