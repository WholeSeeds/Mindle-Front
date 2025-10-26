import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mindle/controllers/nbhd_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/models/complaint.dart';
import 'package:mindle/models/complaint_status.dart';
import 'package:mindle/widgets/align_options_button.dart';
import 'package:mindle/widgets/dropdown_field.dart';
import 'package:mindle/widgets/complaint_card.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';

// 임시 민원 데이터
final List<Complaint> _complaintData = [
  Complaint(
    id: 1,
    title: '도로 신호등이 고장났어요',
    content: '우리 동네 메인 도로 신호등이 고장나서 위험해요. 빨리 수리해 주세요!',
    numLikes: 120,
    numComments: 45,
    complaintStatus: ComplaintStatus.solved,
    hasImage: true,
  ),
  Complaint(
    id: 2,
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.waiting,
    hasImage: true,
  ),
  Complaint(
    id: 3,
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.solving,
    hasImage: true,
  ),
  Complaint(
    id: 4,
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.waiting,
    hasImage: true,
  ),
  Complaint(
    id: 5,
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.waiting,
    hasImage: true,
  ),
];

class ListPage extends StatelessWidget {
  final controller = Get.find<NbhdController>();

  ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MindleTopAppBar(title: "민원목록", showBackButton: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
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
            Expanded(
              child: ListView.builder(
                itemCount: _complaintData.length,
                itemBuilder: (BuildContext context, int index) {
                  final complaint = _complaintData[index];
                  return Column(
                    children: [
                      ComplaintCard(
                        complaint: complaint,
                        onTap: () {
                          Get.toNamed('/complaint_detail/${complaint.id}');
                        },
                      ),
                      Spacing.vertical12,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
