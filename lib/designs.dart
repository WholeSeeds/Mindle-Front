import 'package:flutter/material.dart';

// 색상
// 사용 예시: Text('asdf', style: TextStyle(color: MindleColors.mainGreen))
class MindleColors {
  static const Color mainGreen = Color(0xFF00D482);
  static const Color sudYellow = Color(0xFFFDD130);

  static const Color black = Color(0xFF111111);
  static const Color white = Color(0xFFFFFFFF);

  static const Color gray1 = Color(0xFF767676); // 회색글자
  static const Color gray2 = Color(0xFF5E5F60); // 하단바 아이콘
  static const Color gray3 = Color(0xFFF9FAFB); // 배경
  static const Color gray4 = Color(0xFFF1F3F5); // 비활성화
  static const Color gray5 = Color(0xFFBEBEBE); // 비활성화 글자
  static const Color gray6 = Color(0xFFEDEDED); // 라인
  static const Color gray7 = Color(0xFF474747); // 비활성화 글자
  static const Color gray8 = Color(0xFF8B8B8B);

  static const Color errorRed = Color(0xFFE82300);
  static const Color attentionYellow = Color(0xFFFFCC00);
  static const Color attentionYellow2 = Color(0xFFD5A800);
  static const Color successGreen = Color(0xFF2B9E1E);
  static const Color infoBlue = Color(0xFF0080F8);
}

// 텍스트 스타일
// 사용 예시: Text('asdf', style: MindleTextStyles.headline1())
// 사용 예시: Text('asdf', style: MindleTextStyles.headline1(color: MindleColors.mainGreen))

class MindleTextStyles {
  static TextStyle headline1({Color? color}) => TextStyle(
    color: color ?? MindleColors.black,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Pretendard',
  );

  static TextStyle subtitle1({Color? color}) => TextStyle(
    color: color ?? MindleColors.black,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: 'Pretendard',
  );

  static TextStyle subtitle2({Color? color}) => TextStyle(
    color: color ?? MindleColors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Pretendard',
  );

  static TextStyle subtitle3({Color? color}) => TextStyle(
    color: color ?? MindleColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Pretendard',
  );

  static TextStyle body1({Color? color}) => TextStyle(
    color: color ?? MindleColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Pretendard',
  );

  static TextStyle body2({Color? color}) => TextStyle(
    color: color ?? MindleColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Pretendard',
  );

  static TextStyle body3({Color? color}) => TextStyle(
    color: color ?? MindleColors.black,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    fontFamily: 'Pretendard',
  );

  static TextStyle body4({Color? color}) => TextStyle(
    color: color ?? MindleColors.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Pretendard',
  );

  static TextStyle body5({Color? color}) => TextStyle(
    color: color ?? MindleColors.black,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontFamily: 'Pretendard',
  );

  static TextStyle number1({Color? color}) => TextStyle(
    color: color ?? MindleColors.black,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Pretendard',
  );

  static TextStyle number2({Color? color}) => TextStyle(
    color: color ?? MindleColors.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Pretendard',
  );
}

// 테마
// 사용 예시: GetMaterialApp(theme: MindleThemes.lightTheme)
class MindleThemes {
  // 라이트 테마(기본)
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: MindleColors.mainGreen,
      onPrimary: MindleColors.white,
      secondary: MindleColors.sudYellow,
      onSecondary: MindleColors.black,
      error: MindleColors.errorRed,
      onError: MindleColors.white,
      surface: MindleColors.gray3,
      onSurface: MindleColors.black,
    ),
    fontFamily: 'Pretendard',
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        fontFamily: 'Pretendard',
        color: MindleColors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        fontFamily: 'Pretendard',
        color: MindleColors.black,
      ),
      displaySmall: MindleTextStyles.headline1(),

      headlineLarge: MindleTextStyles.headline1(),
      headlineMedium: MindleTextStyles.subtitle1(),
      headlineSmall: MindleTextStyles.subtitle2(),

      bodyLarge: MindleTextStyles.body1(),
      bodyMedium: MindleTextStyles.body2(),
      bodySmall: MindleTextStyles.body3(),

      labelLarge: MindleTextStyles.body2(),
      labelMedium: MindleTextStyles.body4(),
      labelSmall: MindleTextStyles.body5(),
    ),
  );

  // 다크 테마는 필요시 추가
}

// 앱 전체에서 사용할 공통 spacing 위젯들
// 사용 예시: Spacing.vertical12, Spacing.horizontal8
class Spacing {
  // Vertical Spacing
  static const SizedBox vertical4 = SizedBox(height: 4);
  static const SizedBox vertical8 = SizedBox(height: 8);
  static const SizedBox vertical12 = SizedBox(height: 12);
  static const SizedBox vertical16 = SizedBox(height: 16);
  static const SizedBox vertical20 = SizedBox(height: 20);
  static const SizedBox vertical24 = SizedBox(height: 24);
  static const SizedBox vertical30 = SizedBox(height: 30);

  // Horizontal Spacing
  static const SizedBox horizontal4 = SizedBox(width: 4);
  static const SizedBox horizontal8 = SizedBox(width: 8);
  static const SizedBox horizontal12 = SizedBox(width: 12);
  static const SizedBox horizontal16 = SizedBox(width: 16);
  static const SizedBox horizontal20 = SizedBox(width: 20);
  static const SizedBox horizontal24 = SizedBox(width: 24);
  static const SizedBox horizontal30 = SizedBox(width: 30);
}
