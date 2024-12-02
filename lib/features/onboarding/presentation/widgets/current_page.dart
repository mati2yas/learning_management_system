import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CurrentPage extends StatelessWidget {
  final String image, description;

  const CurrentPage({
    super.key,
    required this.image,
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
                RichText(
                  textAlign: TextAlign.center, // Center-align the text
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Welcome to ",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: "L",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xff44B529),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: "A",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xffFFD700),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: "L",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xffE52828),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center, // Center-align the description
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
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
