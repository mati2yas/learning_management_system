import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';

class BioTextContainer extends StatelessWidget {
  final String bioString;
  final TextStyle textStyle;
  final double maxWidth;
  const BioTextContainer({
    super.key,
    required this.bioString,
    required this.textStyle,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(text: bioString, style: textStyle),
      maxLines: null, // Allow unlimited lines
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final textHeight = textPainter.height;

    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      width: maxWidth,
      // Add padding/margins
      constraints: BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: Text(
        bioString,
        style: textStyle,
        textAlign: TextAlign.start,
      ),
    );
  }
}
