import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/models/complaint.dart';
import 'package:mindle/models/complaint_status.dart';

import 'package:mindle/widgets/align_options_button.dart';
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
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    resolved: false,
    latitude: 37.123456,
    longitude: 127.123456,
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
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    resolved: false,
    latitude: 37.123456,
    longitude: 127.123456,
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
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    resolved: false,
    latitude: 37.123456,
    longitude: 127.123456,
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
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    resolved: false,
    latitude: 37.123456,
    longitude: 127.123456,
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
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    resolved: false,
    latitude: 37.123456,
    longitude: 127.123456,
  ),
];

class CommentedComplaintsPage extends StatelessWidget {
  const CommentedComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MindleTopAppBar(title: '내가 작성한 댓글'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/filled/Message_square.svg',
                    width: 80,
                    height: 80,
                  ),
                  Spacing.vertical4,
                  Text("내가 작성한 댓글", style: MindleTextStyles.subtitle2()),
                  Spacing.vertical4,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("지금까지 ", style: MindleTextStyles.body4()),
                      Text(
                        "${_complaintData.length}개",
                        style: MindleTextStyles.body4(
                          color: MindleColors.mainGreen,
                        ),
                      ),
                      Text("의 댓글을 작성했어요!", style: MindleTextStyles.body4()),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacing.vertical20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Spacer(), AlignOptionsButton()],
                  ),
                  Spacing.vertical12,

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _complaintData.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ComplaintCard(
                            complaint: _complaintData[index],
                            onTap: () {
                              Get.toNamed(
                                '/complaint_detail/${_complaintData[index].id}',
                              );
                            },
                          ),
                          Spacing.vertical12,
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
