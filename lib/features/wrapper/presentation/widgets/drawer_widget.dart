import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/auth_status_registration/provider/auth_status_controller.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
import 'package:lms_system/features/notification/provider/notification_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_courses_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_screen_tab_index_prov.dart';
import 'package:lms_system/features/profile/provider/profile_provider.dart';
import 'package:lms_system/features/saved/provider/saved_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer(builder: (context, ref, child) {
      final pageNavController = ref.read(pageNavigationProvider.notifier);
      var userState = ref.watch(currentUserProvider);
      return Drawer(
        width: size.width * 0.65,
        backgroundColor: AppColors.mainBlue,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 128,
                child: userState.when(
                  error: (error, stack) {
                    return Text(error.toString());
                  },
                  loading: () => const Text("Loading User..."),
                  data: (user) {
                    return Row(
                      spacing: 10,
                      children: [
                        SizedBox(
                          height: 75,
                          width: 75,
                          child: CircleAvatar(
                            backgroundImage: FileImage(File(user.image)),
                            radius: 75,
                          ),
                        ),
                        NameTextContainer(
                          name: user.name,
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                          maxWidth: size.width * 0.65 - 115,
                          // width of drawer - avatar width - row spacing. (115 = avatar width (75) + row spacing (10) + padding on both sides - 15 each)
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Divider(),
              ListTileButton(
                onTap: () {
                  ref
                      .read(notificationApiProvider.notifier)
                      .fetchNotifs(page: 1);
                  Navigator.of(context).pushNamed(Routes.notifications);
                },
                iconData: Icons.notifications_outlined,
                titleText: "Notification",
              ),
              ListTileButton(
                onTap: () {
                  ref.read(profileProvider.notifier).fetchUserData();
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(Routes.profile);
                },
                iconData: Icons.person_outline,
                titleText: "Profile",
              ),
              ListTileButton(
                onTap: () {
                  pageNavController.navigateTo(
                    nextScreen: AppInts.paidPageIndex,
                  );

                  ref.read(paidScreenTabIndexProv.notifier).changeTabIndex(0);
                  ref
                      .refresh(savedApiProvider.notifier)
                      .fetchSavedCoursesData();

                  ref
                      .refresh(paidCoursesApiProvider.notifier)
                      .fetchPaidCourses();

                  if (context.mounted) {
                    Navigator.of(context).pushNamed(Routes.bookmarkedCourses);
                  }
                },
                iconData: Icons.school_outlined,
                titleText: "Saved Courses",
              ),
              // ListTileButton(
              //   onTap: () {
              //     ref.read(paidScreenTabIndexProv.notifier).changeTabIndex(1);
              //       pageNavController.navigateTo(
              //           nextScreen: AppInts.paidPageIndex);

              //       ref.refresh(paidExamsApiProvider.notifier).fetchPaidExams();

              //       ref.refresh(paidExamsApiProvider.notifier).fetchPaidExams();

              //       if (context.mounted) {
              //         Navigator.of(context).pushNamed(Routes.bookmarkedExams);
              //       }
              //   },
              //   iconData: Icons.person_outline,
              //   titleText: "Saved Exams",
              // ),
              ListTileButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(Routes.faq);
                },
                iconData: Icons.help_outline,
                titleText: "FAQ",
              ),
              ListTileButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(Routes.contactUs);
                },
                iconData: Icons.phone_outlined,
                titleText: "Contact",
              ),
              ListTileButton(
                onTap: () async {
                  // ref.read(authStatusProvider.notifier).clearStatus();
                  // ref
                  //     .read(authStatusProvider.notifier)
                  //     .setAuthStatus(AuthStatus.pending);
                  // ref.invalidate(currentUserProvider);
                  // Navigator.pop(context);
                  // Navigator.of(context).pushReplacementNamed(Routes.login);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   UtilFunctions.buildInfoSnackbar(
                  //     message: "Logged Out Successfully.",
                  //   ),
                  // );

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Are You Sure?"),
                      content: const Text(
                          "Are You Certain That You Want To Log Out?"),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            ref.read(authStatusProvider.notifier).clearStatus();
                            ref
                                .read(authStatusProvider.notifier)
                                .setAuthStatus(AuthStatus.pending);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                UtilFunctions.buildInfoSnackbar(
                                    message: "Logged Out Successfully."),
                              );

                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.login);
                            }
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: AppColors.mainBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                iconData: Icons.logout_outlined,
                titleText: "logout",
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ListTileButton extends StatelessWidget {
  final IconData iconData;
  final String titleText;
  final Function onTap;
  const ListTileButton({
    super.key,
    required this.iconData,
    required this.titleText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      leading: Container(
        height: 28,
        width: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Icon(
          iconData,
          color: AppColors.mainBlue,
        ),
      ),
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
      ),
    );
  }
}

class NameTextContainer extends StatelessWidget {
  final String name;
  final TextStyle textStyle;
  final double maxWidth;

  const NameTextContainer({
    super.key,
    required this.name,
    required this.textStyle,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the actual height of the text
    final textPainter = TextPainter(
      text: TextSpan(text: name, style: textStyle),
      maxLines: null, // Allow unlimited lines
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final textHeight = textPainter.height;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8),
      width: maxWidth,
      height: textHeight + 20, // Add padding/margins
      child: Text(
        name,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
