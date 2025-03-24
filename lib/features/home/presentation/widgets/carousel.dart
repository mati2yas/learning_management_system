import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_urls.dart';

class CarouselPage extends StatelessWidget {
  final String tag, img;

  const CarouselPage({
    super.key,
    required this.tag,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.mainBlue,
          width: 1,
        ),
        boxShadow: const [BoxShadow()],
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.3, 0.6],
          colors: [
            AppColors.mainBlue,
            // AppColors.mainBlue.withValues(alpha: 0.3),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 7,
              child: Text(
                tag,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )),
          Expanded(
            flex: 5,
            child: Image.asset(
              "assets/images/$img",
            ),
          )
        ],
      ),
    );
  }
}

class CarouselPageNetwork extends StatelessWidget {
  final String tag, img;

  const CarouselPageNetwork({
    super.key,
    required this.tag,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.mainBlue,
          width: 1,
        ),
        boxShadow: const [BoxShadow()],
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.3, 0.6],
          colors: [
            AppColors.mainBlue,
            // AppColors.mainBlue.withValues(alpha: 0.3),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 7,
              child: Text(
                tag,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )),
          Expanded(
            flex: 5,
            child: Image.network(
              height: 90,
              width: double.infinity,
              getCarouselUrl(img),
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Image.asset(
                  "assets/images/online_course1.png",
                  fit: BoxFit.cover,
                  height: 90,
                  width: double.infinity,
                );
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                // Show an error widget if the image failed to load

                return Image.asset(
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  "assets/images/online_course1.png",
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String getCarouselUrl(String input) {
    input = input.replaceAll("\\", "");
    String finalInput = AppUrls.backendStorage + input;
    debugPrint("carousel image: $finalInput");
    return finalInput;
  }
}
