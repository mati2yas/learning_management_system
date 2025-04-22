import 'package:flutter/material.dart';

class CategoryIndicator extends StatelessWidget {
  final String title;

  final Color colorLighter, colorDarker;
  final bool isWideScreen;
  const CategoryIndicator({
    super.key,
    required this.title,
    required this.colorDarker,
    required this.colorLighter,
    required this.isWideScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        height: isWideScreen ? 80 : 60,
        width: isWideScreen ? 150 : 100,
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
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isWideScreen ? 17 : 13,
            ),
          ),
        ),
      ),
    );
  }
}
