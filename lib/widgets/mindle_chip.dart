import 'package:flutter/material.dart';
import '../designs.dart';

class MindleChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const MindleChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor ?? MindleColors.gray3,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: MindleTextStyles.body3(
            color: textColor ?? MindleColors.mainGreen,
          ),
        ),
      ),
    );
  }
}
