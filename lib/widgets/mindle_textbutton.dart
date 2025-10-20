import 'package:flutter/material.dart';

class MindleTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;

  static const Color mainGreen = Color(0xFF00D482);

  const MindleTextButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.textColor = Colors.white,
    this.backgroundColor = mainGreen,
    this.fontSize = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(label, style: TextStyle(fontSize: fontSize)),
        ),
      ),
    );
  }
}
