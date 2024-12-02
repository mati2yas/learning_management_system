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
      height: 110,
      width: 90,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 90,
              width: 90,
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
            top: 0,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(width: 5, color: Colors.white),
              ),
              child: CircleAvatar(
                radius: 30,
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
