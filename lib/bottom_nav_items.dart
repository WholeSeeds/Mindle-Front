// 하단바 탭 구성 정보
// 각 탭은 연결된 페이지, 아이콘, 라벨로 구성됨
// RootPage에서 currentIndex에 따라 해당 페이지를 보여주는 방식으로 사용

import 'package:flutter/material.dart';
import 'package:mindle/pages/home_page.dart';
import 'package:mindle/pages/list_page.dart';
import 'package:mindle/pages/map_page.dart';
import 'package:mindle/pages/mypage/profile_page.dart';
import 'package:mindle/pages/stats_page.dart';

class BottomNavItem {
  final Widget page;
  final Widget activeIcon;
  final Widget inactiveIcon;
  final String label;

  const BottomNavItem({
    required this.page,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}

final List<BottomNavItem> bottomNavItems = [
  BottomNavItem(
    page: HomePage(),
    activeIcon: Image.asset(
      'assets/icons/filled_home.png',
      width: 24,
      height: 24,
    ),
    inactiveIcon: Image.asset(
      'assets/icons/empty_home.png',
      width: 24,
      height: 24,
    ),
    label: '홈',
  ),
  BottomNavItem(
    page: StatsPage(),
    activeIcon: Image.asset(
      'assets/icons/filled_analyze.png',
      width: 24,
      height: 24,
    ),
    inactiveIcon: Image.asset(
      'assets/icons/empty_analyze.png',
      width: 24,
      height: 24,
    ),
    label: '통계',
  ),
  BottomNavItem(
    page: MapPage(),
    activeIcon: Image.asset(
      'assets/icons/green_empty_complain.png',
      width: 24,
      height: 24,
    ),
    inactiveIcon: Image.asset(
      'assets/icons/empty_complain.png',
      width: 24,
      height: 24,
    ),
    label: '민원작성',
  ),
  BottomNavItem(
    page: ListPage(),
    activeIcon: Image.asset(
      'assets/icons/filled_list.png',
      width: 24,
      height: 24,
    ),
    inactiveIcon: Image.asset(
      'assets/icons/empty_list.png',
      width: 24,
      height: 24,
    ),
    label: '민원목록',
  ),
  BottomNavItem(
    page: ProfilePage(),
    activeIcon: Image.asset(
      'assets/icons/filled_profile.png',
      width: 24,
      height: 24,
    ),
    inactiveIcon: Image.asset(
      'assets/icons/empty_profile.png',
      width: 24,
      height: 24,
    ),
    label: '내 정보',
  ),
];
