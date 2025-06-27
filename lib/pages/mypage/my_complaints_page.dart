import 'package:flutter/material.dart';

import 'package:mindle/widgets/align_options_button.dart';
import 'package:mindle/widgets/complaint_card.dart';

class MyComplaintsPage extends StatelessWidget {
  const MyComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("내가 작성한 민원"), centerTitle: true),
      body: Column(
        children: [
          AlignOptionsButton(),
          ComplaintCard(
            title: "불만사항 1",
            content: "그냥 짜증나요;;",
            numLikes: 100,
            numComments: 22,
            status: "no",
          ),
          ComplaintCard(
            title: "불만사항 2",
            content: "열기도 더 더해지고 너무 힘들어요.",
            numLikes: 18,
            numComments: 2,
            status: "accepted",
          ),
          ComplaintCard(
            title: "불만사항 3",
            content: "아아아",
            numLikes: 5,
            numComments: 0,
            status: "no",
          ),
        ],
      ),
    );
  }
}
