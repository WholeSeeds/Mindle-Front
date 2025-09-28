import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../designs.dart';

class MindleSnackbar {
  /// 기본 Mindle Snackbar
  static void show({
    required String message,
    Duration duration = const Duration(seconds: 1),
    SnackPosition position = SnackPosition.BOTTOM,
    Color backgroundColor = MindleColors.gray1,
    Color textColor = Colors.white,
    double borderRadius = 12,
  }) {
    Get.rawSnackbar(
      message: message,
      snackPosition: position,
      duration: duration,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(
        message,
        style: MindleTextStyles.body2(color: textColor),
      ),
    );
  }

  /// 성공용 Snackbar
  static void success(String message) {
    show(message: message, backgroundColor: MindleColors.mainGreen);
  }

  /// 에러용 Snackbar
  static void error(String message) {
    show(message: message, backgroundColor: Colors.redAccent);
  }

  /// 정보용 Snackbar
  static void info(String message) {
    show(
      message: message,
      backgroundColor: MindleColors.gray7,
      textColor: MindleColors.gray1,
    );
  }
}
