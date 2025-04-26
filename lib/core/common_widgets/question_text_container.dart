import 'package:flutter/material.dart';

class QuestionTextContainer extends StatelessWidget {
  final String question;
  final TextStyle textStyle;
  final double maxWidth;

  const QuestionTextContainer({
    super.key,
    required this.question,
    required this.textStyle,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the actual height of the text
    final textPainter = TextPainter(
      text: TextSpan(text: question, style: textStyle),
      maxLines: null, // Allow unlimited lines
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final textHeight = textPainter.height;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: maxWidth,
      height: textHeight + 20, // Add padding/margins
      child: Text(
        question,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
