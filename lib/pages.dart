import 'package:get/get.dart';
import 'package:mindle/main.dart';
import 'package:mindle/pages/tmp_page.dart';

List<GetPage> allPages = [
  GetPage(name: '/', page: () => const RootPage()),
  GetPage(name: '/tmp', page: () => const TmpPage()),
];
