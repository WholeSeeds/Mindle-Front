import 'package:flutter/material.dart';

class AlignOptionsButton extends StatelessWidget {
  const AlignOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton.icon(
        iconAlignment: IconAlignment.end,
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
    );
  }
}

class _SortOptionsBottomSheet extends StatelessWidget {
  const _SortOptionsBottomSheet();

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
