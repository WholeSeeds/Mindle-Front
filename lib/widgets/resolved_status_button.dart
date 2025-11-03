import 'package:flutter/material.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/widgets/mindle_textbutton.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResolvedStatusButton extends StatelessWidget {
  const ResolvedStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return _SortOptionsBottomSheet();
          },
        );
      },
      child: Row(
        children: [
          Text(
            '처리상태',
            style: MindleTextStyles.body2(
              color: MindleColors.gray8,
            ).copyWith(fontWeight: FontWeight.w500),
          ),
          Spacing.horizontal4,
          SvgPicture.asset(
            'assets/icons/chevron-left.svg',
            height: 22,
            width: 22,
            color: MindleColors.gray8,
          ),
        ],
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
        Spacing.vertical30,
        Text(
          '처리 상태',
          style: MindleTextStyles.subtitle2(
            color: MindleColors.black,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        Spacing.vertical20,
        ListBody(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Center(
                child: Text(
                  '처리 완료',
                  style: MindleTextStyles.body1(
                    color: MindleColors.black,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              onTap: () {
                // 최신순 정렬 로직 추가
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Center(
                child: Text(
                  '처리중',
                  style: MindleTextStyles.body1(
                    color: MindleColors.black,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              onTap: () {
                // 공감순 정렬 로직 추가
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Center(
                child: Text(
                  '대기',
                  style: MindleTextStyles.body1(
                    color: MindleColors.black,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              onTap: () {
                // 댓글순 정렬 로직 추가
                Navigator.pop(context);
              },
            ),
          ],
        ),
        Spacing.vertical16,
        // 하단 버튼
        Container(
          padding: const EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MindleTextButton(
                label: '취소',
                onPressed: () {
                  Navigator.pop(context);
                },
                textColor: MindleColors.gray1,
                backgroundColor: Colors.transparent,
                fontWeight: FontWeight.w600,
                hasBorder: true,
              ),
              Spacing.horizontal16,
              MindleTextButton(
                label: '확인',
                onPressed: () {
                  // 정렬 옵션 적용 로직 추가
                  Navigator.pop(context);
                },
                textColor: MindleColors.gray5, // Colors.white,
                backgroundColor: MindleColors.gray4, // MindleColors.mainGreen,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
