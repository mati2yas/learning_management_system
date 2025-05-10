import 'package:flutter/material.dart';

class InsideButtonCustomLoader extends StatelessWidget {
  const InsideButtonCustomLoader({
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
