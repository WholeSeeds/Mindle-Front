import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mindle/controllers/nbhd_controller.dart';
import 'package:mindle/widgets/align_options_button.dart';
import 'package:mindle/widgets/dropdown_field.dart';
import 'package:mindle/widgets/complaint_card.dart';

// 임시 민원 데이터
final List<Map<String, dynamic>> _complaintData = const [
  {
    "title": "횡단보도 선이 거의 지워졌어요",
    "content":
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    "numLikes": 45,
    "numComments": 2,
    "status": "no",
    "hasImage": true,
  },
  {
    "title": "Test",
    "content": "test",
    "numLikes": 100,
    "numComments": 21,
    "status": "solved",
    "hasImage": false,
  },
  {
    "title": "Test 2",
    "content": "test",
    "numLikes": 10,
    "numComments": 1,
    "status": "accepted",
    "hasImage": false,
  },
  {
    "title": "횡단보도 선이 거의 지워졌어요",
    "content":
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    "numLikes": 45,
    "numComments": 2,
    "status": "no",
    "hasImage": false,
  },
];

class ListPage extends StatelessWidget {
  final controller = Get.find<NbhdController>();

  ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          // 필터링
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // 지역 선택
                  DropdownField(
                    hint: "시/군",
                    value: controller.selectedFirst.value,
                    items: controller.firstList.toList(),
                    onChanged: (String? n) {},
                  ),
                  DropdownField(
                    hint: "구/읍/면/동",
                    value: controller.selectedSecond.value,
                    items: controller.secondList.toList(),
                    onChanged: (String? n) {},
                  ),
                  Visibility(
                    visible: controller.thirdList.isNotEmpty,
                    child: DropdownField(
                      hint: "동",
                      value: controller.selectedThird.value,
                      items: controller.thirdList.toList(),
                      onChanged: (String? n) {},
                    ),
                  ),

                  // 카테고리 선택
                  DropdownField(
                    hint: "카테고리",
                    value: '',
                    items: [],
                    onChanged: (String? n) {},
                  ),

                  // 해결 여부 선택
                  DropdownField(
                    hint: "해결 여부",
                    value: '',
                    items: [],
                    onChanged: (String? n) {},
                  ),
                ],
              ),
            ),
          ),

          // 정렬
          AlignOptionsButton(),

          // 민원 목록
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView.builder(
              itemCount: _complaintData.length,
              itemBuilder: (BuildContext context, int index) {
                final complaint = _complaintData[index];
                return ComplaintCard(
                  title: complaint["title"] as String,
                  content: complaint["content"] as String,
                  numLikes: complaint["numLikes"] as int,
                  numComments: complaint["numComments"] as int,
                  status: complaint["status"] as String,
                  hasImage: complaint["hasImage"] as bool,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
