import 'package:flutter/material.dart';

class CategoryIndicator extends StatelessWidget {
  final String title, image;

  final Color color;
  const CategoryIndicator({
    super.key,
    required this.title,
    required this.image,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      width: 75,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 75,
              width: 75,
              padding: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  textAlign: TextAlign.center,
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -5,
            left: 11,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                border: Border.all(width: 3, color: Colors.white),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                foregroundImage: AssetImage(
                  "assets/images/$image",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
