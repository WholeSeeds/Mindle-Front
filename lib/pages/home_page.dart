import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindle/widgets/resolved_complaint_card.dart';
import 'package:mindle/widgets/hero_profile_card.dart';
import 'package:mindle/widgets/mindle_drawer.dart';
import '../designs.dart';
import '../widgets/mindle_chip.dart';
import '../models/complaint.dart';
import '../models/complaint_status.dart';
import '../models/user.dart';

// 임시 민원 데이터
final List<Complaint> _complaintData = [
  Complaint(
    title: '도로 신호등이 고장났어요',
    content: '우리 동네 메인 도로 신호등이 고장나서 위험해요. 빨리 수리해 주세요!',
    numLikes: 120,
    numComments: 45,
    complaintStatus: ComplaintStatus.solved,
    hasImage: true,
    // TODO: 실제 이미지 URL로 교체 필요
    // imageUrl: 'https://picsum.photos/120/120?random=11'
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

// 임시 유저 데이터
final List<User> _userData = [
  User(
    id: 1,
    firebaseUid: 'firebase_uid_1',
    email: 'minwon_king@example.com',
    phone: '010-1234-5678',
    provider: 'google',
    nickname: '나는 민원왕',
    notificationPush: true,
    notificationInapp: true,
    contributionScore: 1458,
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
    updatedAt: DateTime.now(),
    subdistrict: Subdistrict(code: '41131101', name: '처인구 김량장동', type: 'DONG'),
  ),
  User(
    id: 2,
    firebaseUid: 'firebase_uid_2',
    email: 'hong@example.com',
    phone: '010-2345-6789',
    provider: 'kakao',
    nickname: '홍길동',
    notificationPush: true,
    notificationInapp: false,
    contributionScore: 1004,
    createdAt: DateTime.now().subtract(const Duration(days: 200)),
    updatedAt: DateTime.now(),
    subdistrict: Subdistrict(code: '41131102', name: '처인구 역북동', type: 'DONG'),
  ),
  User(
    id: 3,
    firebaseUid: 'firebase_uid_3',
    email: 'yongin_guardian@example.com',
    phone: '010-3456-7890',
    provider: 'google',
    nickname: '용인 지킴이',
    notificationPush: false,
    notificationInapp: true,
    contributionScore: 856,
    createdAt: DateTime.now().subtract(const Duration(days: 120)),
    updatedAt: DateTime.now(),
    subdistrict: Subdistrict(code: '41131103', name: '처인구 삼가동', type: 'DONG'),
  ),
  User(
    id: 4,
    firebaseUid: 'firebase_uid_4',
    email: 'citizen4135@example.com',
    phone: '010-4567-8901',
    provider: 'apple',
    nickname: '시민4135',
    notificationPush: true,
    notificationInapp: true,
    contributionScore: 324,
    createdAt: DateTime.now().subtract(const Duration(days: 80)),
    updatedAt: DateTime.now(),
    subdistrict: Subdistrict(code: '41131104', name: '처인구 고림동', type: 'DONG'),
  ),
  User(
    id: 5,
    firebaseUid: 'firebase_uid_5',
    email: 'kim8gwan@example.com',
    phone: '010-5678-9012',
    provider: 'kakao',
    nickname: '김팔관',
    notificationPush: false,
    notificationInapp: false,
    contributionScore: 45,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
    subdistrict: Subdistrict(code: '41131105', name: '처인구 신갈동', type: 'DONG'),
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.07;
    return Scaffold(
      drawer: const MindleDrawer(),
      appBar: AppBar(
        backgroundColor: MindleColors.mainGreen,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        shadowColor: Colors.transparent,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: SvgPicture.asset(
                'assets/icons/filled/Burger.svg',
                height: size,
                width: size,
                color: MindleColors.gray3,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
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
              children: _complaintData.map((complaint) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ResolvedComplaintCard(complaint: complaint),
                );
              }).toList(),
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
          ..._userData.map(
            (user) => Column(
              children: [
                HeroProfileCard(user: user),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
