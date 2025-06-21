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
              decoration: const InputDecoration(labelText: '제목'),
              onChanged: (v) => controller.title.value = v,
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(labelText: '내용'),
              maxLines: 5,
              maxLength: 200, // 최대 글자수 제한
              onChanged: (v) => controller.content.value = v,
            ),
            const SizedBox(height: 20),
            // 이미지 업로드 부분 추가하기
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
