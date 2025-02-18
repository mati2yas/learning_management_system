import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/profile/provider/profile_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                        Positioned(
                          top: 20,
                          left: size.width * 0.5,
                          child: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.mainGrey,
                              foregroundColor: Colors.black,
                              iconSize: 24,
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
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
                    onPressed: () {},
                    label: Text(
                      "Notification",
                      style: textTh.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    icon: const Icon((Icons.notifications)),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      pageNavController.navigatePage(2);
                      Navigator.pop(context);
                    },
                    label: Text(
                      "My Courses",
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
                      final prefs = await SharedPreferences.getInstance();
                      prefs.remove("userData");
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
