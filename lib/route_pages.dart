// GetMaterialApp의 getPages에 등록되는 라우팅 정보
// GetPage를 통해 명시적으로 라우트를 등록: Get.toNamed('/tmp')와 같은 URL 기반의 내비게이션 가능해짐
// 하단바로 접근되는 페이지들은 RootPage에서 Obx()로 관리되어 제외

import 'package:get/get.dart';
import 'package:mindle/main.dart';
import 'package:mindle/pages/inside_page.dart';
import 'package:mindle/pages/init_page.dart';

List<GetPage> allPages = [
  GetPage(name: '/init', page: () => const InitPage()),
  GetPage(name: '/', page: () => const RootPage()),
  GetPage(name: '/inside', page: () => const InsidePage()),
];
