import 'package:flutter/material.dart';
import 'package:mindle/models/complaint_status.dart';

import 'package:mindle/widgets/align_options_button.dart';
import 'package:mindle/widgets/complaint_card.dart';

class CommentedComplaintsPage extends StatelessWidget {
  const CommentedComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("내가 댓글 단 민원"), centerTitle: true),
      body: Column(
        children: [
          AlignOptionsButton(),
          ComplaintCard(
            title: "불만사항 1",
            content: "그냥 짜증나요;;",
            numLikes: 100,
            numComments: 22,
            complaintStatus: ComplaintStatus.waiting,
          ),
          ComplaintCard(
            title: "불만사항 2",
            content: "열기도 더 더해지고 너무 힘들어요.",
            numLikes: 18,
            numComments: 2,
            complaintStatus: ComplaintStatus.solved,
          ),
          ComplaintCard(
            title: "불만사항 3",
            content: "아아아",
            numLikes: 5,
            numComments: 0,
            complaintStatus: ComplaintStatus.waiting,
          ),
        ],
      ),
    );
  }
}
