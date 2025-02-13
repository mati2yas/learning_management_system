import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/profile/provider/profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(profileControlerProvider);
    final profileController = ref.watch(profileControlerProvider.notifier);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(titleText: "Profile"),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height * 0.25,
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 30,
                      sigmaY: 30,
                      tileMode: TileMode.clamp,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      child: Image.asset(
                        width: size.width,
                        height: size.height * 0.18,
                        "assets/images/web_design.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: size.width * 0.5 -
                        (50 +
                            12), // 50 for radius of circle and 12 for the padding of screen on left
                    child: const CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/profile_pic.png"),
                      radius: 50,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: size.width * 0.5,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.mainGrey,
                        foregroundColor: Colors.black,
                        iconSize: 24,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.image),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                userState.name,
                style: textTh.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                userState.email,
                style: textTh.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              userState.bio,
              style: textTh.bodyMedium!.copyWith(
                color: AppColors.mainGrey,
              ),
            ),
            const SizedBox(height: 28),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.profileEdit);
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
              onPressed: () {},
              label: Text(
                "My Exam",
                style: textTh.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon((Icons.pending)),
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text(
                "My Education",
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
      ),
    );
  }
}
