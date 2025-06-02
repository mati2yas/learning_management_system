import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/custom_dialog.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/common_widgets/flexible_text_container.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/build_button_label_method.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/auth_status_registration/provider/auth_status_controller.dart';
import 'package:lms_system/features/edit_profile/provider/edit_profile_provider.dart';
import 'package:lms_system/features/notification/provider/notification_provider.dart';
import 'package:lms_system/features/profile/provider/profile_provider.dart';
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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: AppColors.mainBlue2,
                      radius: 50,
                      backgroundImage: user.image.isNotEmpty
                          ? FileImage(
                              File(user
                                  .image), // Replace 'imagePath' with the actual path obtained from the database
                            )
                          : AssetImage(
                              "assets/images/pfp-placeholder.jpg",
                            ),
                    ),
                  ),
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: size.height * 0.25,
                  //   child: Stack(
                  //     children: [
                  //       DecoratedBox(
                  //         decoration: BoxDecoration(
                  //           color: Colors.white.withValues(alpha: 0.7),
                  //         ),
                  //         child: user.image.isNotEmpty
                  //             ? Image.file(
                  //                 File(user
                  //                     .image), // Replace 'imagePath' with the actual path obtained from the database
                  //                 width: size.width,
                  //                 height: size.height * 0.25,
                  //                 fit: BoxFit.cover,
                  //               )
                  //             : Image.asset(
                  //                 "assets/images/pfp-placeholder.jpg",
                  //                 width: size.width,
                  //                 height: size.height * 0.25,
                  //                 fit: BoxFit.cover,
                  //               ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 26),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        var reff = ref.refresh(editProfileProvider.notifier);
                        debugPrint("ref mounted? ${reff.mounted}");
                        await Navigator.of(context)
                            .pushNamed(Routes.profileEdit);
                      },
                      child: Container(
                        width: 130,
                        height: 40,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.mainBlue2, width: 1),
                            borderRadius: BorderRadius.circular(24)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: AppColors.mainBlue2,
                            ),
                            Gap(
                              width: 5,
                            ),
                            Text(
                              "Edit Profile",
                              style: textTh.labelLarge!.copyWith(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Name",
                      style: textTh.bodyMedium!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: size.width,
                      height: 45,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        user.name,
                        style: textTh.bodyMedium!.copyWith(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Email",
                      style: textTh.bodyMedium!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: size.width,
                      height: 45,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        user.email,
                        style: textTh.bodyMedium!.copyWith(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Bio",
                      style: textTh.bodyMedium!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: BioTextContainer(
                      bioString: user.bio,
                      textStyle: textTh.bodyMedium!.copyWith(),
                      maxWidth: size.width,
                    ),
                  ),

                  // TextButton.icon(
                  //   onPressed: () {
                  //     ref
                  //         .refresh(notificationApiProvider.notifier)
                  //         .fetchNotifs(page: 1);
                  //     Navigator.of(context).pushNamed(Routes.notifications);
                  //   },
                  //   label: Text(
                  //     "Notifications",
                  //     style: textTh.titleMedium!.copyWith(
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  //   icon: const Icon((Icons.notifications)),
                  // ),
                  // TextButton.icon(
                  //   onPressed: () async {

                  //   },
                  //   label: Text(
                  //     "Saved Courses",
                  //     style: textTh.titleMedium!.copyWith(
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  //   icon: const Icon((Icons.pending)),
                  // ),
                  // TextButton.icon(
                  //   onPressed: () async {

                  //   },
                  //   label: Text(
                  //     "Saved Exams",
                  //     style: textTh.titleMedium!.copyWith(
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  //   icon: const Icon((Icons.school)),
                  // ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async {
                        showCustomDialog(
                          context: context,
                          title: 'Confirm Logout',
                          content: Text('Are you sure you want to log out?',
                              textAlign: TextAlign.center),
                          onConfirm: () async {
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
                          onCancel: () {
                            Navigator.pop(context);
                          },
                          icon: Icons.logout,
                          iconColor: Colors.red,
                          confirmText: 'Logout',
                          cancelText: 'Cancel',
                        );
                        // showDialog(
                        //   context: context,
                        //   builder: (ctx) => AlertDialog(
                        //     // title: const Text("Are You Sure?"),
                        //     content: const Text(
                        //         "Are you sure you want to log out? We'll miss you!"),
                        //     actions: [
                        //       TextButton(
                        //         onPressed: () async {
                        //           ref
                        //               .read(authStatusProvider.notifier)
                        //               .clearStatus();
                        //           ref
                        //               .read(authStatusProvider.notifier)
                        //               .setAuthStatus(AuthStatus.pending);

                        //           if (context.mounted) {
                        //             ScaffoldMessenger.of(context).showSnackBar(
                        //               UtilFunctions.buildInfoSnackbar(
                        //                   message: "Logged Out Successfully."),
                        //             );
                        //             Navigator.pop(context);
                        //             Navigator.pop(context);
                        //             Navigator.of(context)
                        //                 .pushReplacementNamed(Routes.login);
                        //           }
                        //         },
                        //         child: const Text(
                        //           "Logout",
                        //           style: TextStyle(
                        //             color: Colors.red,
                        //           ),
                        //         ),
                        //       ),
                        //       TextButton(
                        //         onPressed: () => Navigator.pop(context),
                        //         child: const Text(
                        //           "Cancel",
                        //           style: TextStyle(
                        //             color: AppColors.mainBlue,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // );
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
