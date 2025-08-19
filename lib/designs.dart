import 'package:flutter/material.dart';

// 색상
// 사용 예시: color: MindleColors.mainGreen
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
// 사용 예시: style: MindleTextStyles.headline1
class MindleTextStyles {
  static const TextStyle headline1 = TextStyle(
    color: MindleColors.black,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Pretendard',
  );

  static const TextStyle subtitle1 = TextStyle(
    color: MindleColors.black,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: 'Pretendard',
  );

  static const TextStyle subtitle2 = TextStyle(
    color: MindleColors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Pretendard',
  );

  static const TextStyle subtitle3 = TextStyle(
    color: MindleColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Pretendard',
  );

  static const TextStyle body1 = TextStyle(
    color: MindleColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Pretendard',
  );

  static const TextStyle body2 = TextStyle(
    color: MindleColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Pretendard',
  );

  static const TextStyle body3 = TextStyle(
    color: MindleColors.black,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    fontFamily: 'Pretendard',
  );

  static const TextStyle body4 = TextStyle(
    color: MindleColors.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Pretendard',
  );

  static const TextStyle body5 = TextStyle(
    color: MindleColors.black,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontFamily: 'Pretendard',
  );

  static const TextStyle number1 = TextStyle(
    color: MindleColors.black,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Pretendard',
  );

  static const TextStyle number2 = TextStyle(
    color: MindleColors.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Pretendard',
  );
}

// 테마
// 사용 예시: theme: MindleThemes.lightTheme
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
    textTheme: const TextTheme(
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
      displaySmall: MindleTextStyles.headline1,

      headlineLarge: MindleTextStyles.headline1,
      headlineMedium: MindleTextStyles.subtitle1,
      headlineSmall: MindleTextStyles.subtitle2,

      bodyLarge: MindleTextStyles.body1,
      bodyMedium: MindleTextStyles.body2,
      bodySmall: MindleTextStyles.body3,

      labelLarge: MindleTextStyles.body2,
      labelMedium: MindleTextStyles.body4,
      labelSmall: MindleTextStyles.body5,
    ),
  );

  // 다크 테마는 필요시 추가
}
