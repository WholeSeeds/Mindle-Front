// 하단바 탭 구성 정보
// 각 탭은 연결된 페이지, 아이콘, 라벨로 구성됨
// RootPage에서 currentIndex에 따라 해당 페이지를 보여주는 방식으로 사용

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindle/pages/home_page.dart';
import 'package:mindle/pages/list_page.dart';
import 'package:mindle/pages/map_page.dart';
import 'package:mindle/pages/mypage/profile_page.dart';
import 'package:mindle/pages/stats_page.dart';

class BottomNavItem {
  final Widget page;
  final Widget Function(BuildContext context) activeIconBuilder;
  final Widget Function(BuildContext context) inactiveIconBuilder;
  final String label;

  const BottomNavItem({
    required this.page,
    required this.activeIconBuilder,
    required this.inactiveIconBuilder,
    required this.label,
  });
}

// 아이콘 생성 헬퍼 함수
Widget buildIcon(BuildContext context, String path, {double scale = 0.08}) {
  final size = MediaQuery.of(context).size.width * scale;
  return SvgPicture.asset(path, width: size, height: size);
}

final List<BottomNavItem> bottomNavItems = [
  BottomNavItem(
    page: HomePage(),
    activeIconBuilder: (ctx) => buildIcon(ctx, 'assets/icons/filled/Home.svg'),
    inactiveIconBuilder: (ctx) => buildIcon(ctx, 'assets/icons/empty/Home.svg'),
    label: '홈',
  ),
  BottomNavItem(
    page: StatsPage(),
    activeIconBuilder: (ctx) => buildIcon(ctx, 'assets/icons/filled/Graph.svg'),
    inactiveIconBuilder: (ctx) =>
        buildIcon(ctx, 'assets/icons/empty/Graph.svg'),
    label: '통계',
  ),
  BottomNavItem(
    page: MapPage(),
    activeIconBuilder: (ctx) => buildIcon(
      ctx,
      'assets/icons/empty/Green-Hand-FiveFinger.svg',
      scale: 0.08,
    ),
    inactiveIconBuilder: (ctx) =>
        buildIcon(ctx, 'assets/icons/empty/Hand-FiveFinger.svg', scale: 0.09),
    label: '민원작성',
  ),
  BottomNavItem(
    page: ListPage(),
    activeIconBuilder: (ctx) =>
        buildIcon(ctx, 'assets/icons/filled/Document.svg'),
    inactiveIconBuilder: (ctx) =>
        buildIcon(ctx, 'assets/icons/empty/Document.svg'),
    label: '민원목록',
  ),
  BottomNavItem(
    page: ProfilePage(),
    activeIconBuilder: (ctx) => buildIcon(ctx, 'assets/icons/filled/User.svg'),
    inactiveIconBuilder: (ctx) => buildIcon(ctx, 'assets/icons/empty/User.svg'),
    label: '마이페이지',
  ),
];
