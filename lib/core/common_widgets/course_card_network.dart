import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';
import 'package:lms_system/features/requests/provider/requests_provider.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

fetchImageWithPlaceHolder(String imageUrl) {
  return CachedNetworkImage(
    imageUrl: "",
    placeholder: (context, url) => placeHolderAssetWidget(),
    errorWidget: (context, url, error) {
      //print("url: $url, error: ${error.toString()}");
      return Container(
        color: Colors.red,
        child: Text(
          error.toString(),
          style: const TextStyle(color: Colors.yellow),
        ),
      );
    },
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(
            Colors.transparent,
            BlendMode.colorBurn,
          ),
        ),
      ),
    ),
  );
}

Widget placeHolderAssetWidget() {
  return ClipRRect(
    child: Image.asset(
      height: 90,
      width: double.infinity,
      'assets/images/bg_placeholder.jpg',
      fit: BoxFit.cover,
    ),
  );
}

class CourseCardWithImage extends ConsumerWidget {
  final Course course;
  Function? onBookmark;
  Function? onLike;

  CourseCardWithImage({
    super.key,
    required this.course,
    this.onBookmark,
    this.onLike,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(course.image);
    String urlee =
        "http://redonline.cdnds.net/main/thumbs/25788/stack_of_books.jpg";

    var textTh = Theme.of(context).textTheme;
    final requestsController = ref.watch(requestsProvider.notifier);
    return Container(
      width: double.infinity,
      height: 185,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: AppColors.mainGrey,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            // child: fetchImageWithPlaceHolder(
            //   // "${ApiConstants.imageBaseUrl}/${course.image}",
            //  course.image,
            // ),
            child: Image.network(
              height: 80,
              width: double.infinity,
              "${course.image}.jpg", //?? "",
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Image.asset(
                  fit: BoxFit.cover,
                  "assets/images/applied_math.png",
                  height: 80,
                  width: double.infinity,
                );
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                // Show an error widget if the image failed to load

                return Image.asset(
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    "assets/images/applied_math.png");
              },
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              course.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.mainBlue,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svgs/topics.svg",
                  width: 12,
                  height: 12,
                  colorFilter: const ColorFilter.mode(
                    AppColors.mainBlue,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "${course.topics} Topics",
                  style: const TextStyle(color: AppColors.darkerGrey),
                ),
              ],
            ),
          ),
          if (course.subscribed) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    if (onLike != null) {
                      onLike!();
                    }
                  },
                  icon: Icon(
                    course.liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    color: AppColors.mainBlue,
                  ),
                  label: Text("${course.likes}"),
                ),
                const Spacer(),
                TextButton.icon(
                  // style: TextButton.styleFrom(
                  //     padding: const EdgeInsets.only(left: 8)),
                  onPressed: () {
                    if (onBookmark != null) {
                      onBookmark!();
                    }
                  },
                  icon: Icon(
                    course.saved ? Icons.bookmark : Icons.bookmark_outline,
                    color: AppColors.mainBlue,
                  ),
                  label: Text("${course.saves}"),
                ),
              ],
            ),
          ] else ...[
            if (course.onSalePrices[SubscriptionType.oneMonth] != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${course.price[SubscriptionType.oneMonth]}',
                        style: const TextStyle(
                          decoration: TextDecoration
                              .lineThrough, // Strikethrough effect
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            " ${course.onSalePrices[SubscriptionType.oneMonth]}",
                        style: const TextStyle(
                          color: AppColors.mainBlue,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            GestureDetector(
              onTap: () {
                String status = requestsController.addOrRemoveCourse(course);
                if (status == "added") {
                  Navigator.of(context).pushNamed(Routes.requests);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Course has been $status."),
                  ),
                );
              },
              onLongPress: () {
                String status = requestsController.addOrRemoveCourse(course);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Course has been $status."),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.mainBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Buy",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.lock,
                      size: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}
