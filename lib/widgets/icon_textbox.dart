import 'package:flutter/material.dart';

class IconTextBox extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final double fontSize;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsets padding;

  static const Color mainGreen = Color(0xFF00D482);
  static const Color gray4 = Color(0xFFF1F3F5);

  const IconTextBox({
    super.key,
    required this.text,
    this.icon,
    this.iconColor,
    this.textColor,
    this.fontSize = 14,
    this.borderColor,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = text.isEmpty;

    return Container(
      padding: padding,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? (isEmpty ? gray4 : mainGreen)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          (icon != null)
              ? Icon(icon, color: iconColor ?? (isEmpty ? gray4 : mainGreen))
              : SizedBox.shrink(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isEmpty ? "내용 없음" : text,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor ?? (isEmpty ? gray4 : mainGreen),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
