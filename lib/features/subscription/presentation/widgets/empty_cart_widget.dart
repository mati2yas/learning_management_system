import 'package:flutter/material.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({
    super.key,
    required this.textTh,
  });

  final TextTheme textTh;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 100,
        child: Text(
          "Cart is empty , add some courses/exams!",
          style: textTh.bodyLarge!.copyWith(),
        ),
      ),
    );
  }
}
