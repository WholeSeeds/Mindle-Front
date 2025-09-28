import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/models/complaint.dart';
import 'package:mindle/models/complaint_status.dart';

import 'package:mindle/widgets/align_options_button.dart';
import 'package:mindle/widgets/complaint_card.dart';

// 임시 민원 데이터
final List<Complaint> _complaintData = [
  Complaint(
    title: '도로 신호등이 고장났어요',
    content: '우리 동네 메인 도로 신호등이 고장나서 위험해요. 빨리 수리해 주세요!',
    numLikes: 120,
    numComments: 45,
    complaintStatus: ComplaintStatus.solved,
    hasImage: true,
  ),
  Complaint(
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.waiting,
    hasImage: true,
  ),
  Complaint(
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.solving,
    hasImage: true,
  ),
  Complaint(
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.waiting,
    hasImage: true,
  ),
  Complaint(
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.waiting,
    hasImage: true,
  ),
];

class CommentedComplaintsPage extends StatelessWidget {
  const CommentedComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("내가 작성한 댓글"), centerTitle: true),
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
                  SizedBox(height: 4),
                  Text("내가 작성한 댓글", style: MindleTextStyles.subtitle2()),
                  SizedBox(height: 4),
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
                  AlignOptionsButton(),
                  ...List.generate(
                    _complaintData.length,
                    (index) => Column(
                      children: [
                        ComplaintCard(complaint: _complaintData[index]),
                        const SizedBox(height: 12),
                      ],
                    ),
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
