import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CurrentPage extends StatelessWidget {
  final String image, description, title;

  const CurrentPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final double svgHeight = MediaQuery.of(context).size.height * 0.3;

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SVG image centered
          SizedBox(
            height: svgHeight,
            child: SvgPicture.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20), // Spacing between SVG and text
          // Text and description centered
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center, // Center-align the description
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
