import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/notification/provider/notification_provider.dart';
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
          loading: () => const CircularProgressIndicator(
                color: AppColors.mainBlue,
                strokeWidth: 5,
              ),
          error: (error, stack) => Center(
                child: Text(
                  ApiExceptions.getExceptionMessage(error as Exception, 400),
                  style: textTh.titleMedium!.copyWith(color: Colors.red),
                ),
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
                                  height: size.height * 0.18,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/pfp-placeholder.jpg",
                                  width: size.width,
                                  height: size.height * 0.18,
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
                      ref.read(notificationApiProvider.notifier).fetchNotifs();
                      Navigator.of(context).pushNamed(Routes.notifications);
                    },
                    label: Text(
                      "Notification",
                      style: textTh.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    icon: const Icon((Icons.notifications)),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      //pageNavController.navigatePage(2);
                      await ref
                          .read(savedApiProvider.notifier)
                          .fetchSavedCoursesData();
                      if (context.mounted) {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.savedCourses);
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
                    onPressed: () {},
                    label: Text(
                      "My Exams",
                      style: textTh.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    icon: const Icon((Icons.school)),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await SecureStorageService().deleteUser();
                      if (context.mounted) {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.login);
                      }
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
          }),
    );
  }
}
