import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'firebase_options.dart';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:mindle/controllers/bottom_nav_controller.dart';
import 'package:mindle/controllers/auth_controller.dart';
import 'package:mindle/controllers/nbhd_controller.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/bottom_nav_items.dart';
import 'package:mindle/controllers/complaint_controller.dart';
import 'package:mindle/controllers/phone_auth_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/route_pages.dart';
import 'package:mindle/services/google_place_service.dart';
import 'package:mindle/services/naver_maps_service.dart';
import 'package:mindle/widgets/mindle_bottom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:mindle/widgets/mindle_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print('✅ .env 파일 로드 성공');
    
    // LiveKit 설정 확인
    print('📡 LiveKit 설정:');
    print('   SERVER_URL: ${dotenv.env['LIVEKIT_SERVER_URL']}');
    print('   API_KEY: ${dotenv.env['LIVEKIT_API_KEY']}');
  } catch (e) {
    print('❌ .env 파일 로드 실패: $e');
  }

  // 구글 로그인을 위한 Firebase 초기화
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase 초기화 성공');
  } catch (e) {
    print('❌ Firebase 초기화 실패: $e');
    print('Firebase 없이 앱을 계속 진행합니다.');
  }

  // Firebase 초기화 여부와 관계없이 컨트롤러는 항상 생성
  // (Firebase 초기화 실패 시 AuthController 내부에서 null 체크로 처리)
  Get.put(AuthController());
  Get.put(PhoneAuthController());

  // 카카오 로그인을 위한 카카오 SDK 초기화
  try {
    KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);
    print('✅ 카카오 SDK 초기화 성공');
  } catch (e) {
    print('❌ 카카오 SDK 초기화 실패: $e');
  }

  // 네이버 지도 초기화: client Id를 지정
  try {
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
    print('✅ 네이버 지도 초기화 성공');
  } catch (e) {
    print('❌ 네이버 지도 초기화 실패: $e');
  }

  Get.put(BottomNavController());
  Get.put(LocationController());
  Get.put(NbhdController());
  Get.put(ComplaintController());
  Get.put(
    NaverMapsService(
      clientId: dotenv.env['NAVER_MAP_CLIENT_ID'] ?? '',
      clientSecret: dotenv.env['NAVER_MAP_CLIENT_SECRET'] ?? '',
    ),
  );
  Get.put(
    GooglePlaceService(
      apiKey: dotenv.env['GOOGLE_MAPS_PLATFORM_API_KEY'] ?? '',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WholeSeeds',
      theme: MindleThemes.lightTheme,
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
    final locationController = Get.find<LocationController>();

    DateTime? backPressedTime;

    return Obx(
      () => WillPopScope(
        // 기기의 뒤로가기 클릭 시 동작 정의
        onWillPop: () async {
          // 위치 선택 모드에서는 바로 뒤로가기
          if (locationController.isSelectingLocation.value) {
            return true;
          }

          // TODO: 드로어가 열려있으면 바로 드로어 닫기 처리하기

          DateTime nowTime = DateTime.now();
          if (backPressedTime == null ||
              nowTime.difference(backPressedTime!) >
                  const Duration(seconds: 2)) {
            backPressedTime = nowTime;
            MindleSnackbar.show(message: '한 번 더 누르시면 종료됩니다.');
            return false; // 앱 종료 안함
          }
          return true; // 앱 종료
        },
        child: Scaffold(
          body: bottomNavItems[controller.currentIndex.value].page,
          bottomNavigationBar: locationController.isSelectingLocation.value
              ? null
              : MindleBottomNavigationBar(controller: controller),
        ),
      ),
    );
  }
}
