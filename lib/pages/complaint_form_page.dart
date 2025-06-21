import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mindle/controllers/complaint_controller.dart';
import 'package:mindle/models/public_place.dart';
import 'package:get/get.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';

class ComplaintFormPage extends StatelessWidget {
  final PublicPlace place;

  ComplaintFormPage({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ComplaintController>();
    return Scaffold(
      appBar: MindleTopAppBar(title: "민원 작성"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(place.name, style: const TextStyle(fontSize: 20)),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.selectedCategory.value,
                items: controller.categoryList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.isEmpty ? '카테고리 선택' : e),
                      ),
                    )
                    .toList(),
                onChanged: (v) => controller.selectedCategory.value = v ?? '',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(
                labelText: '제목을 입력해주세요 (필수)',
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              onChanged: (v) => controller.title.value = v,
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(
                labelText: '어떤 점이 불편하셨나요?',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              maxLength: 200, // 최대 글자수 제한
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
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => controller.images.remove(img),
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
            ElevatedButton(
              onPressed: () => controller.submitComplaint(place),
              child: const Text('등록하기'),
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
