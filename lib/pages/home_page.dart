import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('홈'),
            TextButton(
              onPressed: () => Get.toNamed('/inside'),
              child: const Text('다음 페이지'),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:mindle/designs.dart'; // MindleColors, MindleTextStyles, MindleThemes 포함
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mindle Theme Preview'),
//         backgroundColor: MindleColors.gray3,
//         foregroundColor: MindleColors.black,
//         elevation: 0,
//       ),
//       backgroundColor: MindleColors.gray3,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const _SectionTitle('🎨 MindleColors'),
//             const SizedBox(height: 12),
//             Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               children: [
//                 _colorBox(MindleColors.mainGreen, 'mainGreen'),
//                 _colorBox(MindleColors.sudYellow, 'sudYellow'),
//                 _colorBox(MindleColors.black, 'black'),
//                 _colorBox(MindleColors.white, 'white'),
//                 _colorBox(MindleColors.gray1, 'gray1'),
//                 _colorBox(MindleColors.gray2, 'gray2'),
//                 _colorBox(MindleColors.gray3, 'gray3'),
//                 _colorBox(MindleColors.gray4, 'gray4'),
//                 _colorBox(MindleColors.gray5, 'gray5'),
//                 _colorBox(MindleColors.gray6, 'gray6'),
//                 _colorBox(MindleColors.gray7, 'gray7'),
//                 _colorBox(MindleColors.gray8, 'gray8'),
//                 _colorBox(MindleColors.errorRed, 'errorRed'),
//                 _colorBox(MindleColors.attentionYellow, 'attentionYellow'),
//                 _colorBox(MindleColors.attentionYellow2, 'attentionYellow2'),
//                 _colorBox(MindleColors.successGreen, 'successGreen'),
//                 _colorBox(MindleColors.infoBlue, 'infoBlue'),
//               ],
//             ),
//
//             const SizedBox(height: 24),
//             const _SectionTitle('🖋 MindleTextStyles'),
//             const SizedBox(height: 12),
//             _textSample('headline1', MindleTextStyles.headline1()),
//             _textSample('subtitle1', MindleTextStyles.subtitle1()),
//             _textSample('subtitle2', MindleTextStyles.subtitle2()),
//             _textSample('subtitle3', MindleTextStyles.subtitle3()),
//             _textSample('body1', MindleTextStyles.body1()),
//             _textSample('body2', MindleTextStyles.body2()),
//             _textSample('body3', MindleTextStyles.body3()),
//             _textSample('body4', MindleTextStyles.body4()),
//             _textSample('body5', MindleTextStyles.body5()),
//             _textSample('number1', MindleTextStyles.number1()),
//             _textSample('number2', MindleTextStyles.number2()),
//
//             const SizedBox(height: 24),
//             const _SectionTitle('🖋 Theme Text Styles'),
//             const SizedBox(height: 12),
//             _textSample('Display Large', textTheme.displayLarge),
//             _textSample('Display Medium', textTheme.displayMedium),
//             _textSample('Display Small', textTheme.displaySmall),
//             _textSample('Headline Large', textTheme.headlineLarge),
//             _textSample('Headline Medium', textTheme.headlineMedium),
//             _textSample('Headline Small', textTheme.headlineSmall),
//             _textSample('Body Large', textTheme.bodyLarge),
//             _textSample('Body Medium', textTheme.bodyMedium),
//             _textSample('Body Small', textTheme.bodySmall),
//             _textSample('Label Large', textTheme.labelLarge),
//             _textSample('Label Medium', textTheme.labelMedium),
//             _textSample('Label Small', textTheme.labelSmall),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _colorBox(Color color, String name) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.black12),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(name, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//   }
//
//   Widget _textSample(String name, TextStyle? style) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Text(name, style: style),
//     );
//   }
// }
//
// // 섹션 제목용 위젯
// class _SectionTitle extends StatelessWidget {
//   final String title;
//   const _SectionTitle(this.title);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//         ),
//         const Divider(height: 16, thickness: 1.5),
//       ],
//     );
//   }
// }
