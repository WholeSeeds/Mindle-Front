import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindle/widgets/mindle_textbutton.dart';

class MindleDialog extends StatelessWidget {
  final String title;
  final String content;
  final String firstButton;
  final String? secondButton;
  final VoidCallback? firstButtonAction;
  final VoidCallback? secondButtonAction;

  static const Color mainGreen = Color(0xFF00D482);
  static const Color gray3 = Color(0xFFF9FAFB);
  static const Color gray4 = Color(0xFFF1F3F5);
  static const Color gray5 = Color(0xFFBEBEBE);

  const MindleDialog({
    super.key,
    required this.title,
    required this.content,
    required this.firstButton,
    this.secondButton,
    this.firstButtonAction,
    this.secondButtonAction,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: gray3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(content),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (secondButton != null)
                  MindleTextButton(
                    label: secondButton!,
                    onPressed: () {
                      Navigator.pop(context);
                      if (secondButtonAction != null) {
                        secondButtonAction!();
                      }
                    },
                    textColor: gray5,
                    backgroundColor: gray4,
                  ),
                const SizedBox(width: 10),
                MindleTextButton(
                  label: firstButton,
                  onPressed: () {
                    Navigator.pop(context);
                    if (firstButtonAction != null) {
                      firstButtonAction!();
                    }
                  },
                  textColor: Colors.white,
                  backgroundColor: mainGreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
