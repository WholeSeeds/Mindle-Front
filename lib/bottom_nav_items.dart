// 하단바 탭 구성 정보
// 각 탭은 연결된 페이지, 아이콘, 라벨로 구성됨
// RootPage에서 currentIndex에 따라 해당 페이지를 보여주는 방식으로 사용

import 'package:flutter/material.dart';
import 'package:mindle/pages/home_page.dart';
import 'package:mindle/pages/list_page.dart';
import 'package:mindle/pages/map_page.dart';
import 'package:mindle/pages/profile_page.dart';
import 'package:mindle/pages/stats_page.dart';

class BottomNavItem {
  final Widget page;
  final IconData icon;
  final String label;

  const BottomNavItem({
    required this.page,
    required this.icon,
    required this.label,
  });
}

const List<BottomNavItem> bottomNavItems = [
  BottomNavItem(page: HomePage(), icon: Icons.home, label: '홈'),
  BottomNavItem(page: StatsPage(), icon: Icons.query_stats, label: '통계'),
  BottomNavItem(page: MapPage(), icon: Icons.back_hand, label: '민원작성'),
  BottomNavItem(page: ListPage(), icon: Icons.list, label: '민원목록'),
  BottomNavItem(page: ProfilePage(), icon: Icons.person, label: '내 정보'),
];
