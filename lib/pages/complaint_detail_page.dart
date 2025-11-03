import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/complaint_detail_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComplaintDetailPage extends StatelessWidget {
  final int complaintId;
  const ComplaintDetailPage({Key? key, required this.complaintId})
    : super(key: key);

  // 디자인 가이드 컬러 팔레트
  // TODO: designs.dart 에서 디자인 사용하기
  static const Color mainGreen = Color(0xFF00D482);
  static const Color sudYellow = Color(0xFFFDD130);
  static const Color black = Color(0xFF111111);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray1 = Color(0xFF767676);
  static const Color gray2 = Color(0xFF5E5F60);
  static const Color gray3 = Color(0xFFF9F8FB);
  static const Color gray4 = Color(0xFFF1F3F5);
  static const Color gray5 = Color(0xFFBEBEBE);
  static const Color gray6 = Color(0xFFEDEDED);
  static const Color gray7 = Color(0xFF474747);
  static const Color gray8 = Color(0xFF888888);
  static const Color errorRed = Color(0xFFE82300);
  static const Color infoBlue = Color(0xFF0080F8);

  @override
  Widget build(BuildContext context) {
    final badgePathList = [
      'assets/icons/Badge1.svg',
      'assets/icons/Badge2.svg',
      'assets/icons/Badge3.svg',
      'assets/icons/Badge4.svg',
      'assets/icons/Badge5.svg',
      'assets/icons/Badge6.svg',
      'assets/icons/Badge7.svg',
      'assets/icons/Badge8.svg',
      'assets/icons/Badge9.svg',
      'assets/icons/Badge10.svg',
    ];
    return GetBuilder<ComplaintDetailController>(
      init: ComplaintDetailController()
        ..loadComplaintDetail(complaintId.toString()),
      builder: (controller) {
        if (controller.isLoading.value || controller.complaintDetail == null) {
          return Scaffold(
            backgroundColor: white,
            body: Center(child: CircularProgressIndicator(color: mainGreen)),
          );
        }

        final detail = controller.complaintDetail!;
        final reaction = controller.reactionInfo.value;

        return Scaffold(
          backgroundColor: white,
          appBar: MindleTopAppBar(title: '민원 상세'),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 위치 정보
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/marker-pin-01.png',
                        width: 20,
                        height: 20,
                        color: mainGreen,
                      ),
                      Spacing.horizontal4,
                      Text(
                        detail.placeName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: mainGreen,
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                  Spacing.vertical4,

                  // 카테고리
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/sliders-04.png',
                        width: 20,
                        height: 20,
                        color: mainGreen,
                      ),
                      Spacing.horizontal4,
                      Text(
                        detail.categoryName,
                        style: TextStyle(
                          color: mainGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                  Spacing.vertical12,

                  // 작성자 및 날짜
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: gray3,
                        child: Image.asset(
                          'assets/images/Group 1707485733.png',
                          width: 22,
                          height: 22,
                          color: gray5,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // 닉네임 + 날짜를 Column으로 묶음
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.memberNickname,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: gray1,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          Text(
                            "${detail.createdAt.month.toString().padLeft(2, '0')}/${detail.createdAt.day.toString().padLeft(2, '0')} "
                            "${detail.createdAt.hour.toString().padLeft(2, '0')}:${detail.createdAt.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              color: gray1,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                      PopupMenuButton<String>(
                        icon: SvgPicture.asset(
                          "assets/icons/dots-vertical.svg",
                          width: 22,
                          height: 22,
                        ),
                        onSelected: (value) {
                          if (value == 'delete') {
                            _showDeleteConfirmDialog(
                              context,
                              controller,
                              complaintId,
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: errorRed, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  '삭제하기',
                                  style: MindleTextStyles.body3(
                                    color: errorRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Spacing.vertical8,
                  Divider(color: gray4, thickness: 1),
                  Spacing.vertical8,
                  // 제목과 처리완료 배지
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          detail.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      Spacing.horizontal8,
                      SvgPicture.asset('assets/icons/State1.svg'),
                    ],
                  ),
                  Spacing.vertical8,

                  // 이미지 슬라이더 부분을 다음과 같이 수정
                  if (controller.imagesBytesList.isNotEmpty)
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          child: PageView.builder(
                            itemCount: detail.imageUrls.length,
                            controller: PageController(
                              initialPage: controller.currentImageIndex,
                            ),
                            onPageChanged: (idx) {
                              controller.currentImageIndex = idx;
                              controller.update();
                            },
                            itemBuilder: (context, idx) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    controller.imagesBytesList[idx],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: gray4,
                                        child: Icon(
                                          Icons.image,
                                          color: gray1,
                                          size: 50,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // 이미지 페이지 인디케이터
                        if (controller.imagesBytesList.length > 1)
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${controller.currentImageIndex + 1}/${detail.imageUrls.length}",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                  Spacing.vertical8,
                  // 본문 내용
                  Text(detail.content, style: MindleTextStyles.body1()),
                  Spacing.vertical20,
                  Divider(color: gray4, thickness: 1),

                  // 좋아요 & 댓글 수
                  if (reaction != null)
                    Row(
                      children: [
                        Spacer(),
                        SvgPicture.asset(
                          'assets/icons/empty/Message_square.svg',
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${controller.comments.length}',
                          style: MindleTextStyles.body2(
                            color: MindleColors.gray1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          'assets/icons/empty/Heart.svg',
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${reaction.reactionCount}',
                          style: MindleTextStyles.body2(
                            color: MindleColors.gray1,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),

                  Spacing.vertical20,

                  // 해결된 민원 이미지 Before/After 섹션
                  // TODO: 해결완료여부 필요
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: mainGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // 헤더 부분 (기존과 동일)
                        GestureDetector(
                          onTap: controller.toggleExpanded,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/Group 1707485474.png",
                                  width: 18,
                                  height: 18,
                                  color: white,
                                ),

                                Spacing.horizontal8,
                                Text(
                                  '해결된 민원이에요!',
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  controller.isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Before/After 이미지 -
                        if (controller.isExpanded)
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            child: Container(
                              color: white,
                              padding: EdgeInsets.all(16),
                              child:
                                  detail.imageUrls.length >
                                      2 // 이미지 2장 이상일 때만 표시
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  detail.imageUrls[0],
                                                  height: 140,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Spacing.vertical8,
                                              Text(
                                                'Before',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacing.horizontal16,
                                        Expanded(
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  detail.imageUrls[1],
                                                  height: 140,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Spacing.vertical8,
                                              Text(
                                                'After',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: Text(
                                        '이미지를 불러올 수 없습니다.',
                                        style: MindleTextStyles.body4(
                                          color: gray1,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Spacing.vertical24,
                  Divider(color: gray4, thickness: 1),
                  Spacing.vertical16,

                  // 댓글 리스트
                  if (controller.comments.isEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          '아직 댓글이 없습니다.',
                          style: TextStyle(
                            color: gray1,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.comments.length,
                      separatorBuilder: (_, __) => Divider(color: gray4),
                      itemBuilder: (context, index) {
                        final comment = controller.comments[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: gray3,
                                    child: Image.asset(
                                      'assets/images/Group 1707485733.png',
                                      width: 20,
                                      height: 20,
                                      color: gray5,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: SvgPicture.asset(
                                      badgePathList[7],
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Spacing.horizontal12,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          comment.nickname,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: gray1,
                                            fontFamily: 'Pretendard',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      comment.content,
                                      style: MindleTextStyles.body1(),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "${comment.createdAt.month.toString().padLeft(2, '0')}/${comment.createdAt.day.toString().padLeft(2, '0')} ${comment.createdAt.hour.toString().padLeft(2, '0')}:${comment.createdAt.minute.toString().padLeft(2, '0')}",
                                      style: TextStyle(
                                        color: gray1,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Pretendard',
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: 댓글 좋아요 API 연동 시 구현
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/empty/Heart.svg',
                                            width: 18,
                                            height: 18,
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            '${comment.numLikes}',
                                            style: TextStyle(
                                              color: black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Pretendard',
                                            ),
                                          ),
                                          Spacing.horizontal8,
                                          Text(
                                            '답글',
                                            style: TextStyle(
                                              color: infoBlue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Pretendard',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  Spacing.vertical20,

                  // 댓글 입력창
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: gray4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.commentInputController,
                            decoration: InputDecoration(
                              hintText: "댓글을 입력하세요",
                              hintStyle: TextStyle(
                                color: gray1,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Pretendard',
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: black,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/images/Group 1707485744.png',
                            width: 24,
                            height: 24,
                            color: gray5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacing.vertical20,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    ComplaintDetailController controller,
    int complaintId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            '민원 삭제',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: black,
              fontFamily: 'Pretendard',
            ),
          ),
          content: Text(
            '이 민원을 삭제하시겠습니까?\n삭제된 민원은 복구할 수 없습니다.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: gray1,
              fontFamily: 'Pretendard',
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: gray1,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await controller.deleteComplaint(
                  complaintId.toString(),
                );
                if (success) {
                  Get.back(); // 민원 상세 화면에서 나가기
                }
              },
              child: Text(
                '삭제',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: errorRed,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
