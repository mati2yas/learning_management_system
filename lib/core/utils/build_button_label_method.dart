import 'package:flutter/material.dart';

Widget buildInputLabel(String label, TextTheme textTh) {
  return Text(
    label,
    style: textTh.bodyMedium!.copyWith(
      fontWeight: FontWeight.w600,
    ),
  );
}
