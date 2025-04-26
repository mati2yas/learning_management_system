import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.only(left: 8),
      width: maxWidth,
      height: textHeight + 20, // Add padding/margins
      child: Text(
        bioString,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
