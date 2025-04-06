import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';

class CarouselPage extends StatelessWidget {
  final String tag, img;

  const CarouselPage({
    super.key,
    required this.tag,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: 100,
          color: AppColors.mainBlue.withAlpha(100),
          child: Image.network(
            fit: BoxFit.fitWidth,
            img,
            width: double.infinity,
            height: double.maxFinite,
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 0.3, sigmaX: 0.3),
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.45),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                tag,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.headlineLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.1,
                    // color: yellowFont,
                    fontFamily: "Bakbak One"),
              ),
            ),
          ),
        ),
      ],
    );

    // return Container(
    //   padding: const EdgeInsets.all(8),
    //   margin: const EdgeInsets.symmetric(horizontal: 5),
    //   width: MediaQuery.sizeOf(context).width * 0.9,
    //   height: 150,
    //   decoration: BoxDecoration(
    //     border: Border.all(
    //       color: AppColors.mainBlue,
    //       width: 1,
    //     ),
    //     boxShadow: const [BoxShadow()],
    //     gradient: const LinearGradient(
    //       begin: Alignment.centerLeft,
    //       end: Alignment.centerRight,
    //       stops: [0.3, 0.6],
    //       colors: [
    //         AppColors.mainBlue,
    //         // AppColors.mainBlue.withValues(alpha: 0.3),
    //         Colors.white,
    //       ],
    //     ),
    //     borderRadius: BorderRadius.circular(14),
    //   ),
    //   child: Row(
    //     children: [
    //       Expanded(
    //           flex: 7,
    //           child: Text(
    //             tag,
    //             style: const TextStyle(
    //               color: Colors.white,
    //             ),
    //           )),
    //       Expanded(
    //         flex: 5,
    //         child: Image.asset(
    //           "assets/images/$img",
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}

class CarouselPageNetwork extends StatelessWidget {
  final String tag, imgUrl;

  const CarouselPageNetwork({
    super.key,
    required this.tag,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          16), // Ensures the image and container are clipped
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.blue.withAlpha(100),
            ),
            child: Image.network(
              imgUrl,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Image.asset(
                  "assets/images/online_course1.png",
                  fit: BoxFit.cover,
                  height: 90,
                  width: double.infinity,
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/online_course1.png",
                  fit: BoxFit.cover,
                  height: 90,
                  width: double.infinity,
                );
              },
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 0.3, sigmaX: 0.3),
            child: Container(
              alignment: Alignment.center,
              color: Colors.black.withOpacity(0.45),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  tag,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.1,
                    fontFamily: "Bakbak One",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // return Container(
    //   padding: const EdgeInsets.all(8),
    //   margin: const EdgeInsets.symmetric(horizontal: 5),
    //   width: MediaQuery.sizeOf(context).width * 0.9,
    //   height: 150,
    //   decoration: BoxDecoration(
    //     border: Border.all(
    //       color: AppColors.mainBlue,
    //       width: 1,
    //     ),
    //     boxShadow: const [BoxShadow()],
    //     gradient: const LinearGradient(
    //       begin: Alignment.centerLeft,
    //       end: Alignment.centerRight,
    //       stops: [0.3, 0.6],
    //       colors: [
    //         AppColors.mainBlue,
    //         // AppColors.mainBlue.withValues(alpha: 0.3),
    //         Colors.white,
    //       ],
    //     ),
    //     borderRadius: BorderRadius.circular(14),
    //   ),
    //   child: Row(
    //     children: [
    //       Expanded(
    //           flex: 7,
    //           child: Text(
    //             tag,
    //             style: const TextStyle(
    //               color: Colors.white,
    //             ),
    //           )),
    //       Expanded(
    //         flex: 5,
    //         child:
    //       )
    //     ],
    //   ),
    // );
  }

  // String getCarouselUrl(String input) {
  //   input = input.replaceAll("\\", "");
  //   //String finalInput = "${AppUrls.backendStorage}/$input";
  //   debugPrint("carousel image: $finalInput");
  //   return finalInput;
  // }
}
