import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/paid_courses/provider/paid_courses_provider.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/subscription/provider/requests/course_requests_provider.dart';
import 'package:lms_system/features/subscription/provider/subscriptions/course_subscription_provider.dart';

part 'courses_dialog_widget.dart';

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
    //print(course.image);

    var subscriptionController =
        ref.watch(courseSubscriptionControllerProvider.notifier);

    var requestsProv = ref.watch(courseRequestsProvider);
    var textTh = Theme.of(context).textTheme;

    final paidToggleController = ref.watch(paidCoursesApiProvider.notifier);
    final requestsController = ref.watch(courseRequestsProvider.notifier);
    return Container(
      width: double.infinity,
      height: 185,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: AppColors.mainGrey,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
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
              maxLines: 1,
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
                    AppColors.darkerBlue,
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
                  onPressed: () async {
                    if (onLike != null) {
                      onLike!();
                    }
                    //await paidToggleController.toggleLiked(course);
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
                  onPressed: () async {
                    if (onBookmark != null) {
                      onBookmark!();
                    }
                    //await paidToggleController.toggleSaved(course);
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
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Course Prices'),
                        content: PricesDialogWidget(course: course),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Back'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    spacing: 6,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${course.price[SubscriptionType.oneMonth]}',
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
                                  " ${course.onSalePrices[SubscriptionType.oneMonth]} ETB",
                              style: const TextStyle(
                                color: AppColors.darkerBlue,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.info,
                        color: AppColors.mainBlue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Course Prices'),
                        content: PricesDialogWidget(course: course),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Back'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    spacing: 6,
                    children: [
                      Text(
                        " ${course.price[SubscriptionType.oneMonth]} ETB",
                        style: const TextStyle(
                          color: AppColors.mainBlue,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const Icon(
                        Icons.info,
                        color: AppColors.mainBlue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                var (status, courses) =
                    requestsController.addOrRemoveCourse(course);
                subscriptionController.updateCourses(courses);

                debugPrint("after subscController updateCurse, courses:");
                var subProv = ref.read(courseSubscriptionControllerProvider);
                for (var c in subProv.courses) {
                  print("subProv.courses.current.id: ${c.id}");
                }
                if (status == "added") {
                  Navigator.of(context).pushNamed(Routes.requests);
                }
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.darkerBlue,
                    content: Text(
                      "Course has been $status.",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              onLongPress: () {
                var (status, courses) =
                    requestsController.addOrRemoveCourse(course);

                subscriptionController.updateCourses(courses);

                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.darkerBlue,
                    content: Text(
                      "Course has been $status.",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.mainBlue,
                  borderRadius: BorderRadius.circular(8),
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
