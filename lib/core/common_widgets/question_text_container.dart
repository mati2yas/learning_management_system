import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/fonts.dart';

class QuestionTextContainer extends StatelessWidget {
  final String question;
  final TextStyle textStyle;
  final double maxWidth;
  final int questionNumber;

  const QuestionTextContainer({
    super.key,
    required this.question,
    required this.textStyle,
    required this.maxWidth,
    required this.questionNumber,
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
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: 8, left: 8),
      width: maxWidth,
      // height: textHeight + 30, // Add padding/margins
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionNumber.toString() + ". ",
            style: textTheme.titleMedium!.copyWith(
              letterSpacing: 0.5,
              fontFamily: "Inter",
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              question,
              style: textTheme.titleMedium!.copyWith(
                letterSpacing: 0.5,
                fontFamily: "Inter",
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
