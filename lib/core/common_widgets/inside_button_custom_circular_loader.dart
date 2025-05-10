import 'package:flutter/material.dart';

class InsideButtonCustomCircularLoader extends StatelessWidget {
  const InsideButtonCustomCircularLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }
}
