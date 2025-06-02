import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
import 'package:lms_system/features/edit_profile/provider/change_email_provider.dart';
import 'package:lms_system/features/forgot_password/provider/forgot_password_provider.dart';

// class ChangeEmailScreen extends ConsumerStatefulWidget {
//   const ChangeEmailScreen({super.key});

//   @override
//   ConsumerState<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
// }

// class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
//   List<Widget> bodyWidgets = [];
//   int currentWidget = 0;
//   final TextEditingController emailController = TextEditingController();

//   double maxFormWidth = 400;

//   @override
//   Widget build(BuildContext context) {
//     final editEmailController =
//         ref.watch(changeEmailControllerProvider.notifier);
//     final state = ref.watch(changeEmailControllerProvider);
//     final size = MediaQuery.sizeOf(context);
//     final textTh = Theme.of(context).texthTh;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CommonAppBar(titleText: "Change Email"),
//       body: LayoutBuilder(builder: (context, constraints) {
//         return Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: constraints.maxHeight,
//                 maxWidth: maxFormWidth,
//               ),
//               child: Form(
//                 key: AppKeys.changeEmailFormKey,
//                 child: Column(
//                   children: [
//                     Gap(
//                       height: 20,
//                     ),
//                     Text(
//                       "Please enter your new email address below. We'll send you a verification email shortly. Once verified, you can log in with your new email and your current password. Note: Your current email will no longer be recognized by our platform after verification",
//                       style: textTh.bodyLarge!.copyWith(),
//                     ),
//                     const SizedBox(height: 15),
//                     InputWidget(
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Please enter your email';
//                         }

//                         // Regular expression to validate email format
//                         final emailRegex =
//                             RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//                         if (!emailRegex.hasMatch(value)) {
//                           return 'Please enter a valid email address';
//                         }

//                         return null; // Return null if the input is valid
//                       },
//                       controller: emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       hintText: 'Your Email',
//                       onSaved: (value) {
//                         editEmailController.updateEmail(value!);
//                       },
//                     ),
//                     Gap(),
//                     CustomButton(
//                         isFilledButton: true,
//                         buttonWidget: state.apiStatus == ApiState.busy
//                             ? const Center(
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : state.apiStatus == ApiState.error
//                                 ? Text(
//                                     'Retry',
//                                     style: texthTh.labelLarge!.copyWith(
//                                         letterSpacing: 0.5,
//                                         fontFamily: "Inter",
//                                         color: Colors.white,
//                                         overflow: TextOverflow.ellipsis),
//                                   )
//                                 : Text(
//                                     'Change Email',
//                                     style: texthTh.labelLarge!.copyWith(
//                                         letterSpacing: 0.5,
//                                         fontFamily: "Inter",
//                                         color: Colors.white,
//                                         overflow: TextOverflow.ellipsis),
//                                   ),
//                         buttonAction: () async {
//                           if (AppKeys.changeEmailFormKey.currentState
//                                   ?.validate() ==
//                               true) {
//                             AppKeys.changeEmailFormKey.currentState!.save();
//                             try {
//                               final changeEmailData =
//                                   await editEmailController.changeEmail();

//                               ref.invalidate(currentUserProvider);
//                               if (context.mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   UtilFunctions.buildInfoSnackbar(
//                                     message:
//                                         "Email Changed Successfully. Login with your current password, and new email.",
//                                   ),
//                                 );

//                                 var storageService = SecureStorageService();
//                                 await storageService
//                                     .setUserAuthedStatus(AuthStatus.pending);
//                                 emailController.clear();
//                                 if (context.mounted) {
//                                   Navigator.of(context).pushReplacementNamed(
//                                     Routes.login,
//                                   );
//                                 }
//                               }
//                             } catch (e) {
//                               if (context.mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   UtilFunctions.buildErrorSnackbar(
//                                       errorMessage:
//                                           "Email Change Failed: ${UtilFunctions.stripExceptionLabel(e)}",
//                                       exception: e),
//                                 );
//                               }
//                             }
//                           }
//                         }),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final state = ref.watch(forgotPasswordControllerProvider);
//       emailController.text = state.email;
//       // Example of delayed UI update (often not needed for simple button presses)

//     });
//   }
// }
//final TextTheme textTh = TextTheme(); // Placeholder, adjust as per your setup

class ChangeEmailScreen extends ConsumerStatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  ConsumerState<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
  // List<Widget> bodyWidgets = []; // This line seems unused and can be removed
  // int currentWidget = 0; // This line seems unused and can be removed
  final TextEditingController emailController = TextEditingController();

  double maxFormWidth = 400;

  @override
  Widget build(BuildContext context) {
    final editEmailController =
        ref.watch(changeEmailControllerProvider.notifier);
    final state = ref.watch(changeEmailControllerProvider);
    // final size = MediaQuery.sizeOf(context); // Unused
    final textTh = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(titleText: "Change Email"),
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: maxFormWidth,
              ),
              child: Form(
                key: AppKeys.changeEmailFormKey,
                child: Column(
                  children: [
                    Gap(
                      // Use const for Gap if it's always the same
                      height: 20,
                    ),
                    Text(
                      "Please enter your new email address below. We'll send you a verification email shortly. Once verified, you can log in with your new email and your current password. Note: Your current email will no longer be recognized by our platform after verification",
                      style: textTh.bodyLarge!.copyWith(),
                    ),
                    const SizedBox(height: 15),
                    InputWidget(
                      validator: (value) {
                        if (value.isEmpty) {
                          // Added null check for value
                          return 'Please enter your email';
                        }

                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Your Email',
                      onSaved: (value) {
                        if (value != null) {
                          // Add null check for onSaved value
                          editEmailController.updateEmail(value);
                        }
                      },
                    ),
                    Gap(), // Use const for Gap
                    CustomButton(
                        isFilledButton: true,
                        buttonWidget: state.apiStatus == ApiState.busy
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : state.apiStatus == ApiState.error
                                ? Text(
                                    'Retry',
                                    style: textTh.labelLarge!.copyWith(
                                        letterSpacing: 0.5,
                                        fontFamily: "Inter",
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis),
                                  )
                                : Text(
                                    'Change Email',
                                    style: textTh.labelLarge!.copyWith(
                                        letterSpacing: 0.5,
                                        fontFamily: "Inter",
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                        buttonAction: () async {
                          if (AppKeys.changeEmailFormKey.currentState
                                  ?.validate() ==
                              true) {
                            AppKeys.changeEmailFormKey.currentState!.save();
                            try {
                              // Call the controller method with retry logic
                              final changeEmailData =
                                  await editEmailController.changeEmail();

                              // --- CRITICAL CHANGE HERE ---
                              // Defer UI updates and ref.invalidate to the next frame
                              if (context.mounted) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  if (context.mounted) {
                                    // Check mounted again inside the callback
                                    ref.invalidate(
                                        currentUserProvider); // Now safely invalidated

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      UtilFunctions.buildInfoSnackbar(
                                        message:
                                            "Email Changed Successfully. Login with your current password, and new email.",
                                      ),
                                    );

                                    var storageService = SecureStorageService();
                                    await storageService.setUserAuthedStatus(
                                        AuthStatus.pending);
                                    emailController.clear();

                                    // Navigator operation should also be after mounted check
                                    if (context.mounted) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        Routes.login,
                                      );
                                    }
                                  }
                                });
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  UtilFunctions.buildErrorSnackbar(
                                      errorMessage:
                                          "Email Change Failed: ${UtilFunctions.stripExceptionLabel(e)}",
                                      exception: e),
                                );
                              }
                            }
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure forgotPasswordControllerProvider is available before watching it
      // This could potentially be the cause of initial errors if not correctly setup.
      // If `forgotPasswordControllerProvider` relies on other providers, ensure they are
      // available or initialized before this screen.
      // Also, `ref.watch` in initState is typically discouraged for direct access,
      // `ref.read` is preferred if you need the current state once.
      // However, if `forgotPasswordControllerProvider` is meant to be watched
      // for changes that affect emailController.text *after* init, then `watch` is fine.
      final state = ref.read(
          forgotPasswordControllerProvider); // Changed to ref.read for initState
      emailController.text = state.email;
    });
  }
}
