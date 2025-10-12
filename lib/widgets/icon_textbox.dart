import 'package:flutter/material.dart';
import 'package:mindle/designs.dart';

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
  static const Color gray6 = Color(0xFFEDEDED);

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
        border: Border.all(color: borderColor ?? (isEmpty ? gray6 : mainGreen)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          (icon != null)
              ? Icon(icon, color: iconColor ?? (isEmpty ? gray6 : mainGreen))
              : SizedBox.shrink(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isEmpty ? "" : text,
              style: MindleTextStyles.body1(
                color: textColor ?? (isEmpty ? gray6 : mainGreen),
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
