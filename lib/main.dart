import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'login.dart';

void main() async {
  // .env 파일 로드
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();

  // 구글 로그인을 위한 Firebase 초기화
  await Firebase.initializeApp();

  // 카카오 로그인을 위한 카카오 SDK 초기화
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mindle App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Login(),
    );
  }
}
