import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
import 'package:lms_system/features/edit_profile/provider/edit_profile_provider.dart';
import 'package:lms_system/features/forgot_password/model/forgot_password_model.dart';
import 'package:lms_system/features/forgot_password/provider/change_password_provider.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  final ForgotPasswordModel forgotPasswordModel;
  const ChangePasswordScreen({
    super.key,
    required this.forgotPasswordModel,
  });

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final changePassController =
        ref.watch(changePasswordControllerProvider.notifier);
    final state = ref.watch(changePasswordControllerProvider);
    final size = MediaQuery.sizeOf(context);
    final textTh = Theme.of(context).textTheme;

    double maxFormWidth = 400;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: maxFormWidth,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: AppKeys.changePasswordFormKey,
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Your New Password',
                        style: textTh.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Get your PIN from email.',
                        style: textTh.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Your Email: ${widget.forgotPasswordModel.email}',
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Password (at least 4 characters)',
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InputWidget(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter New Password";
                          }
                          if (value.length < 4) {
                            return "Password must be at least 4 characters long";
                          }
                          return null;
                        },
                        controller: passwordController,
                        hintText: 'Password',
                        obscureOption: true,
                        onSaved: (value) {
                          changePassController.updatePassword(value!);
                        },
                      ),
                      Text(
                        "PIN 6 digits",
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InputWidget(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Your Pin";
                          }

                          return null;
                        },
                        controller: pinController,
                        hintText: 'PIN',
                        obscureOption: true,
                        onSaved: (value) {
                          changePassController.updateToken(value!);
                        },
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainBlue,
                            padding: state.apiStatus == ApiState.busy
                                ? null
                                : const EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 10,
                                  ),
                            fixedSize: Size(
                              size.width - 80,
                              60,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            if (AppKeys.changePasswordFormKey.currentState
                                    ?.validate() ==
                                true) {
                              AppKeys.changePasswordFormKey.currentState!
                                  .save();
                              try {
                                changePassController.updateEmail(
                                    widget.forgotPasswordModel.email);
                                ForgotPasswordState result =
                                    await changePassController.changePassword();
                                if (result.responseSuccess) {
                                  debugPrint(
                                      "response status of changing password is success.");
                                  await SecureStorageService()
                                      .setUserAuthedStatus(AuthStatus.authed);
                                  var refreshData = ref
                                      .refresh(currentUserProvider.notifier)
                                      .build();
                                  var profileRefreshed =
                                      ref.refresh(editProfileProvider.notifier);

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      UtilFunctions.buildInfoSnackbar(
                                        message: "Password Change Successful",
                                      ),
                                    );
                                    passwordController.clear();
                                    pinController.clear();
                                    User? user = await SecureStorageService()
                                        .getUserFromStorage();

                                  
                                    if (context.mounted) {
                                      if ((user?.loginCount ?? 0) > 0) {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                          Routes.wrapper,
                                        );
                                      } else {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                Routes.profileAdd);
                                      }
                                    }
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  if (e.toString() == "Email not verified") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      UtilFunctions.buildErrorSnackbar(
                                        errorMessage: "Change Password Failed:",
                                        exception: e,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      UtilFunctions.buildErrorSnackbar(
                                        errorMessage: "Login Failed:",
                                        exception: e,
                                      ),
                                    );
                                  }
                                }
                              }
                            }
                          },
                          child: state.apiStatus == ApiState.busy
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : state.apiStatus == ApiState.error
                                  ? Text(
                                      'Retry',
                                      style: textTh.titleLarge!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Login',
                                      style: textTh.titleLarge!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final state = ref.watch(changePasswordControllerProvider);
    //   passwordController.text = state.password;
    //   pinController.text = state.pinToken;
    // });
  }
}
