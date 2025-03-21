import 'package:flutter/material.dart';

class CategoryIndicator extends StatelessWidget {
  final String title;

  final Color colorLighter, colorDarker;
  const CategoryIndicator({
    super.key,
    required this.title,
    required this.colorDarker,
    required this.colorLighter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        height: 75,
        width: 120,
        padding: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorDarker,
              colorLighter,
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            textAlign: TextAlign.center,
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
