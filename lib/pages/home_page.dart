import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindle/widgets/resolved_complaint_card.dart';
import 'package:mindle/widgets/hero_profile_card.dart';
import '../designs.dart';
import '../widgets/mindle_chip.dart';
import '../models/complaint.dart';
import '../models/complaint_status.dart';
import '../models/user.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.07;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MindleColors.mainGreen,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/filled/Burger.svg',
            height: size,
            width: size,
            color: MindleColors.gray3,
          ),
          onPressed: () => {},
        ),
        title: SvgPicture.asset(
          'assets/icons/filled/Logo.svg',
          height: size,
          width: size,
          color: MindleColors.gray3,
        ),
        centerTitle: true,
      ),
      backgroundColor: MindleColors.mainGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [const _GreetingSection(), const _ContentContainer()],
          ),
        ),
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘도 민원 한 건!',
            style: MindleTextStyles.subtitle1(color: MindleColors.gray3),
          ),
          Text(
            '동네가 바뀌는 시작입니다',
            style: MindleTextStyles.subtitle1(color: MindleColors.gray3),
          ),
        ],
      ),
    );
  }
}

class _ContentContainer extends StatelessWidget {
  const _ContentContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.8, // ✅ 최소 높이만 지정
      ),
      decoration: BoxDecoration(
        color: MindleColors.gray3,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            _TodayIssuesSection(),
            SizedBox(height: 24),
            _TopComplaintSection(),
            SizedBox(height: 24),
            _ResolvedComplaintsSection(),
            SizedBox(height: 24),
            _WeeklyHeroSection(),
          ],
        ),
      ),
    );
  }
}

class _TodayIssuesSection extends StatelessWidget {
  const _TodayIssuesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('오늘 동네 이슈는?', style: MindleTextStyles.subtitle2()),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                MindleChip(
                  label: '주민 전용 주차 자리',
                  backgroundColor: MindleColors.gray3,
                  borderColor: MindleColors.mainGreen,
                  textColor: MindleColors.mainGreen,
                ),
                const SizedBox(width: 8),
                MindleChip(
                  label: '도로 맨홀',
                  backgroundColor: MindleColors.gray3,
                  borderColor: MindleColors.mainGreen,
                  textColor: MindleColors.mainGreen,
                ),
                const SizedBox(width: 8),
                MindleChip(
                  label: '자전거 방치',
                  backgroundColor: MindleColors.gray3,
                  borderColor: MindleColors.mainGreen,
                  textColor: MindleColors.mainGreen,
                ),
                const SizedBox(width: 8),
                MindleChip(
                  label: '오토바이 소음',
                  backgroundColor: MindleColors.gray3,
                  borderColor: MindleColors.mainGreen,
                  textColor: MindleColors.mainGreen,
                ),
                const SizedBox(width: 8),
                MindleChip(
                  label: '신호등 고장',
                  backgroundColor: MindleColors.gray3,
                  borderColor: MindleColors.mainGreen,
                  textColor: MindleColors.mainGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopComplaintSection extends StatelessWidget {
  const _TopComplaintSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text('우리 동네 공감 1등 민원', style: MindleTextStyles.subtitle2()),
          const SizedBox(height: 12),
          // TODO: 공감 1등 민원 콘텐츠 추가
        ],
      ),
    );
  }
}

class _ResolvedComplaintsSection extends StatelessWidget {
  const _ResolvedComplaintsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text('해결 완료! 이렇게 바뀌었어요', style: MindleTextStyles.subtitle2()),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ResolvedComplaintCard(
                  complaint: Complaint(
                    title: '도로 신호등이 고장났어요',
                    content: '우리 동네 메인 도로 신호등이 고장나서 위험해요. 빨리 수리해 주세요!',
                    numLikes: 120,
                    numComments: 45,
                    complaintStatus: ComplaintStatus.solved,
                    hasImage: true,
                  ),
                ),
                ResolvedComplaintCard(
                  complaint: Complaint(
                    title: '보도블록 파손 신고',
                    content: '아파트 앞 보도블록이 여러 곳 파손되어 있어 보행에 위험합니다.',
                    numLikes: 89,
                    numComments: 23,
                    complaintStatus: ComplaintStatus.solved,
                    hasImage: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyHeroSection extends StatelessWidget {
  const _WeeklyHeroSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text('이번 주 민원 히어로', style: MindleTextStyles.subtitle2()),
          const SizedBox(height: 24),
          HeroProfileCard(
            user: User(
              level: 10,
              name: '나는 민원왕',
              profileImageUrl: 'https://picsum.photos/120/120?random=10',
              complaintCount: 1458,
              solvedComplaintCount: 324,
            ),
          ),
          const SizedBox(height: 12),
          HeroProfileCard(
            user: User(
              level: 7,
              name: '홍길동',
              profileImageUrl: 'https://picsum.photos/120/120?random=11',
              complaintCount: 1004,
              solvedComplaintCount: 145,
            ),
          ),
          const SizedBox(height: 12),
          HeroProfileCard(
            user: User(
              level: 6,
              name: '용인 지킴이',
              profileImageUrl: '', // 빈 이미지로 기본 아이콘 표시
              complaintCount: 9,
              solvedComplaintCount: 4,
            ),
          ),
          const SizedBox(height: 12),
          HeroProfileCard(
            user: User(
              level: 5,
              name: '시민4135',
              profileImageUrl: 'https://picsum.photos/120/120?random=13',
              complaintCount: 1,
              solvedComplaintCount: 1,
            ),
          ),
          const SizedBox(height: 12),
          HeroProfileCard(
            user: User(
              level: 1,
              name: '김팔관',
              profileImageUrl: 'https://picsum.photos/120/120?random=14',
              complaintCount: 1,
              solvedComplaintCount: 0,
            ),
          ),
        ],
      ),
    );
  }
}
