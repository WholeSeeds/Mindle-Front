import 'package:flutter/material.dart';
import 'package:mindle/designs.dart';

class MindleTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  const MindleTextField({
    super.key,
    required this.hint,
    this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MindleColors.gray6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MindleColors.mainGreen),
        ),
      ),
    );
  }
}
