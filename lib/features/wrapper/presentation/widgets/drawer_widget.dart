import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/auth_status_registration/provider/auth_status_controller.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
import 'package:lms_system/features/notification/provider/notification_provider.dart';
import 'package:lms_system/features/profile/provider/profile_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer(builder: (context, ref, child) {
      var userState = ref.watch(currentUserProvider);
      return Drawer(
        width: size.width * 0.6,
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
                        Text(
                          user.name,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Divider(),
              // const ListTileButton(
              //   iconData: Icons.dark_mode,
              //   titleText: "Dark Mode",
              // ),
              ListTileButton(
                onTap: () {
                  ref.read(notificationApiProvider.notifier).fetchNotifs(
                        page: 0,
                        type: NotifType.unread,
                      );
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
                onTap: () {},
                iconData: Icons.help_outline,
                titleText: "FAQ",
              ),
              ListTileButton(
                onTap: () {},
                iconData: Icons.phone_outlined,
                titleText: "Contact",
              ),
              ListTileButton(
                onTap: () async {
                  ref.read(authStatusProvider.notifier).clearStatus();
                  ref
                      .read(authStatusProvider.notifier)
                      .setAuthStatus(AuthStatus.pending);
                  ref.invalidate(currentUserProvider);
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacementNamed(Routes.login);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.darkerBlue,
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        "Logged Out Successfully",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
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
