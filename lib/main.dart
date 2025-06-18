import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:mindle/controllers/bottom_nav_controller.dart';
import 'package:mindle/controllers/nbhd_controller.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/bottom_nav_items.dart';
import 'package:mindle/route_pages.dart';
import 'package:mindle/services/naver_local_search_service.dart';
import 'package:mindle/widgets/mindle_bottom_navigation_bar.dart';
import 'package:get/get.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // 구글 로그인을 위한 Firebase 초기화
  await Firebase.initializeApp();

  // 카카오 로그인을 위한 카카오 SDK 초기화
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);

  // 네이버 지도 초기화: client Id를 지정
  await FlutterNaverMap().init(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID'] ?? '',
    onAuthFailed: (ex) => switch (ex) {
      NQuotaExceededException(:final message) => print(
        "사용량 초과 (message: $message)",
      ),
      NUnauthorizedClientException() ||
      NClientUnspecifiedException() ||
      NAnotherAuthFailedException() => print("인증 실패: $ex"),
    },
  );

  Get.put(BottomNavController());
  Get.put(LocationController());
  Get.put(NbhdController());  
  Get.put(NaverLocalSearchService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WholeSeeds',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // initialRoute는 명시하지 않으면 자동으로 '/'로 지정됨
      initialRoute: "/init",
      getPages: allPages,
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return Obx(
      () => Scaffold(
        body: bottomNavItems[controller.currentIndex.value].page,
        bottomNavigationBar: MindleBottomNavigationBar(controller: controller),
      ),
    );
  }
}
