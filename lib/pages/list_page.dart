import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mindle/controllers/nbhd_controller.dart';
import 'package:mindle/widgets/dropdown_field.dart';
import 'package:mindle/widgets/report_card.dart';

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
          Align(
            alignment: Alignment.topRight,
            child: TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return _SortOptionsBottomSheet();
                  },
                );
              },
              icon: Icon(Icons.sort),
              label: Text('최신순'),
            ),
          ),

          // 민원 목록
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView(
              children: [
                ReportCard(
                  title: "횡단보도 선이 거의 지워졌어요",
                  content:
                      "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
                  numLikes: 45,
                  numComments: 2,
                  status: "no",
                  hasImage: true,
                ),
                ReportCard(
                  title: "Test",
                  content: "test",
                  numLikes: 100,
                  numComments: 21,
                  status: "solved",
                ),
                ReportCard(
                  title: "Test 2",
                  content: "test",
                  numLikes: 10,
                  numComments: 1,
                  status: "accepted",
                ),
                ReportCard(
                  title: "횡단보도 선이 거의 지워졌어요",
                  content:
                      "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
                  numLikes: 45,
                  numComments: 2,
                  status: "no",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SortOptionsBottomSheet extends StatelessWidget {
  const _SortOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.access_time),
          title: Text('최신순'),
          onTap: () {
            // 최신순 정렬 로직 추가
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.favorite_border),
          title: Text('공감순'),
          onTap: () {
            // 공감순 정렬 로직 추가
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.comment_outlined),
          title: Text('댓글순'),
          onTap: () {
            // 댓글순 정렬 로직 추가
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
