import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/shared_course/model/shared_course_model.dart';
import 'package:lms_system/requests/provider/requests_provider.dart';

import '../app_router.dart';

class CourseCard extends ConsumerWidget {
  final Course course;
  Function? onBookmark;
  Function? onLike;

  CourseCard({
    super.key,
    required this.course,
    this.onBookmark,
    this.onLike,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTh = Theme.of(context).textTheme;
    final requestsController = ref.watch(requestsProvider.notifier);
    return Container(
      width: double.infinity,
      height: 160,
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
            child: Image.asset(
              "assets/images/${course.image}",
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                course.title,
                style: const TextStyle(
                  color: AppColors.mainBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
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
                  Text("${course.topics} Topics"),
                  const Spacer(),
                ],
              ),
            ),
          ),
          course.subscribed
              ? Flexible(
                  child: SizedBox(
                    height: 35,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            if (onLike != null) {
                              onLike!();
                            }
                          },
                          icon: Icon(
                            course.liked
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            color: AppColors.mainBlue,
                          ),
                          label: Text("${course.likes}"),
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(left: 8)),
                          onPressed: () {
                            if (onBookmark != null) {
                              onBookmark!();
                            }
                          },
                          icon: Icon(
                            course.saved
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                            color: AppColors.mainBlue,
                          ),
                          label: Text("${course.saves}"),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    onLongPress: () {
                      String status =
                          requestsController.addOrRemoveCourse(course);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Course has been $status."),
                        ),
                      );
                    },
                    onPressed: () {
                      String status =
                          requestsController.addOrRemoveCourse(course);
                      if (status == "added") {
                        Navigator.of(context).pushNamed(Routes.requests);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Course has been $status."),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.mainBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 2,
                      ),
                      foregroundColor: Colors.white,
                      fixedSize: const Size(85, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Buy",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.lock,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
