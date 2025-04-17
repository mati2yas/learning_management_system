import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/auth_status_registration/provider/auth_status_controller.dart';
import 'package:lms_system/features/notification/provider/notification_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_exam_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_screen_tab_index_prov.dart';
import 'package:lms_system/features/profile/provider/profile_provider.dart';
import 'package:lms_system/features/saved/provider/saved_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(profileProvider);

    final pageNavController = ref.read(pageNavigationProvider.notifier);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        titleText: "Profile",
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: userState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.mainBlue,
            strokeWidth: 5,
          ),
        ),
        error: (error, stack) => AsyncErrorWidget(
          errorMsg: error.toString(),
          callback: () async {
            await ref.refresh(profileProvider.notifier).fetchUserData();
          },
        ),
        data: (user) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.25,
                  child: Stack(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        child: user.image.isNotEmpty
                            ? Image.file(
                                File(user
                                    .image), // Replace 'imagePath' with the actual path obtained from the database
                                width: size.width,
                                height: size.height * 0.25,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/pfp-placeholder.jpg",
                                width: size.width,
                                height: size.height * 0.25,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    user.name,
                    style: textTh.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    user.email,
                    style: textTh.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                Center(
                  child: Text(
                    user.bio,
                    style: textTh.bodyMedium!.copyWith(color: Colors.black),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 28),
                TextButton.icon(
                  onPressed: () async {
                    bool? result = await Navigator.of(context)
                        .pushNamed<bool>(Routes.profileEdit);
                    if (result == true) {
                      ref.read(profileProvider.notifier).fetchUserData();
                    }
                  },
                  label: Text(
                    "Edit Profile",
                    style: textTh.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: const Icon((Icons.edit)),
                ),
                TextButton.icon(
                  onPressed: () {
                    ref
                        .refresh(notificationApiProvider.notifier)
                        .fetchNotifs(page: 1);
                    Navigator.of(context).pushNamed(Routes.notifications);
                  },
                  label: Text(
                    "Notifications",
                    style: textTh.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: const Icon((Icons.notifications)),
                ),
                TextButton.icon(
                  onPressed: () async {
                    pageNavController.navigateTo(
                      nextScreen: AppInts.paidPageIndex,
                    );

                    ref
                        .watch(paidScreenTabIndexProv.notifier)
                        .changeTabIndex(0);
                    ref
                        .refresh(savedApiProvider.notifier)
                        .fetchSavedCoursesData();

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  label: Text(
                    "Saved Courses",
                    style: textTh.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: const Icon((Icons.pending)),
                ),
                TextButton.icon(
                  onPressed: () async {
                    ref
                        .watch(paidScreenTabIndexProv.notifier)
                        .changeTabIndex(1);
                    pageNavController.navigateTo(
                        nextScreen: AppInts.paidPageIndex);

                    ref.refresh(paidExamsApiProvider.notifier).fetchPaidExams();

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  label: Text(
                    "Saved Exams",
                    style: textTh.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: const Icon((Icons.school)),
                ),
                TextButton.icon(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Are You Sure?"),
                        content: const Text(
                            "Are You Certain That You Want To Log Out?"),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              ref
                                  .read(authStatusProvider.notifier)
                                  .clearStatus();
                              ref
                                  .read(authStatusProvider.notifier)
                                  .setAuthStatus(AuthStatus.pending);
                              ScaffoldMessenger.of(context).showSnackBar(
                                UtilFunctions.buildInfoSnackbar(
                                    message: "Logged Out Successfully."),
                              );
                              if (context.mounted) {
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.login);
                              }
                            },
                            child: const Text("Logout"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                        ],
                      ),
                    );
                  },
                  label: Text(
                    "Logout",
                    style: textTh.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  icon: const Icon(
                    (Icons.logout),
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
