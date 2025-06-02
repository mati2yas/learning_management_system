import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_courses_provider.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/subscription/provider/requests/course_requests_provider.dart';
import 'package:lms_system/features/subscription/provider/subscriptions/course_subscription_provider.dart';

part 'courses_dialog_widget.dart';

class CourseCardNetworkImage extends ConsumerWidget {
  final Course course;
  Function? onBookmark;
  Function? onLike;
  final double mainAxisExtent;

  CourseCardNetworkImage({
    super.key,
    required this.course,
    required this.mainAxisExtent,
    this.onBookmark,
    this.onLike,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(course.image);
    bool color = course.subscriptionStatus == "expired";
    var subscriptionController =
        ref.watch(courseSubscriptionControllerProvider.notifier);

    var requestsProv = ref.read(courseRequestsProvider);
    var textTh = Theme.of(context).textTheme;

    final paidToggleController = ref.watch(paidCoursesApiProvider.notifier);
    final requestsController = ref.read(courseRequestsProvider.notifier);
    return Card(
      elevation: 3,
      child: Container(
        width: double.infinity,
        height: mainAxisExtent,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: AppColors.mainGrey,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              // child: fetchImageWithPlaceHolder(
              //   // "${ApiConstants.imageBaseUrl}/${course.image}",
              //  course.image,
              // ),
              child: Image.network(
                height: 90,
                width: double.infinity,
                course.image ?? "",
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Image.asset(
                    fit: BoxFit.cover,
                    "assets/images/placeholder_16.png",
                    height: 90,
                    width: double.infinity,
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  // Show an error widget if the image failed to load

                  return Image.asset(
                      height: 90,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      "assets/images/placeholder_16.png");
                },
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                    "${course.topics} Chapters",
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
              if (course.onSalePrices[SubscriptionType.oneMonth] != null ||
                  course.onSalePrices[SubscriptionType.threeMonths] != null ||
                  course.onSalePrices[SubscriptionType.sixMonths] != null ||
                  course.onSalePrices[SubscriptionType.yearly] != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    spacing: 6,
                    children: [
                      Expanded(
                        child: Text(
                          '${course.price[SubscriptionType.oneMonth]} ETB',
                          style: const TextStyle(
                              color: AppColors.darkerBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      // Spacer(),
                      GestureDetector(
                        onTap: () {
                          showCourseSubscriptionOffers(context);
                        },
                        child: Row(
                          children: [
                            const Text(
                              "Onsale",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Gap(width: 5),
                            const Icon(
                              Icons.info,
                              color: AppColors.mainBlue,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      Gap(
                        width: 4,
                      )
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    showCourseSubscriptionOffers(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      spacing: 6,
                      children: [
                        Expanded(
                          child: Text(
                            " ${course.price[SubscriptionType.oneMonth]} ETB",
                            style: const TextStyle(
                                color: AppColors.mainBlue,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const Icon(
                          Icons.info,
                          color: AppColors.mainBlue,
                          size: 25,
                        ),
                        Gap(width: 4),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  var (status, courses) =
                      await requestsController.addOrRemoveCourse(course);
                  subscriptionController.updateCourses(courses);

                  debugPrint("after subscController updateCurse, courses:");
                  var subProv = ref.read(courseSubscriptionControllerProvider);
                  for (var c in subProv.courses) {
                    debugPrint("subProv.courses.current.id: ${c.id}");
                  }
                  if (status == "added") {
                    Navigator.of(context).pushNamed(
                      Routes.subscriptions,
                      arguments: AppInts.subscriptionScreenCourseIndex,
                    );
                  }
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    UtilFunctions.buildInfoSnackbar(
                      message: "Course has been $status.",
                    ),
                  );
                },
                onLongPress: () async {
                  var (status, courses) =
                      await requestsController.addOrRemoveCourse(course);

                  subscriptionController.updateCourses(courses);

                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    UtilFunctions.buildInfoSnackbar(
                      message: "Course has been $status.",
                    ),
                  );
                },
                child: Center(
                  child: Container(
                    width: 120,
                    height: 35,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration: BoxDecoration(
                      //color: AppColors.mainBlue,
                      color: color ? Colors.red : AppColors.mainBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        const Icon(
                          Icons.lock,
                          size: 14,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            color ? "Expired" : "Buy Now",
                            style: const TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(
                height: 7.5,
              )
            ],
          ],
        ),
      ),
    );
  }

  Future<dynamic> showCourseSubscriptionOffers(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.5,
              child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: PricesDialogWidget(course: course)),
            ),
          );
        });
  }
}
