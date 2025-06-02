import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/common_widgets/inside_button_custom_circular_loader.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/core/utils/build_button_label_method.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/auth_status_registration/provider/auth_status_controller.dart';
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(
                        height: 50,
                      ),
                      Text(
                        'Configure your new Password',
                        style: textTh.headlineSmall!.copyWith(
                            // fontWeight: FontWeight.w800,
                            ),
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text:
                                "Get your reset PIN that has been sent your email : ",
                            style: textTh.bodyLarge!.copyWith()),
                        TextSpan(
                            text: "${widget.forgotPasswordModel.email}",
                            style: textTh.bodyLarge!.copyWith(
                                color: AppColors.mainBlue2,
                                fontWeight: FontWeight.bold))
                      ])),
                      Gap(height: 20),
                      buildInputLabel('PIN 6 digits', textTh),
                      Gap(height: 5),
                      InputWidget(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Your Pin";
                          }

                          return null;
                        },
                        controller: pinController,
                        hintText: 'reset pin from email',
                        obscureOption: true,
                        onSaved: (value) {
                          changePassController.updateToken(value!);
                        },
                      ),
                      Gap(height: 20),
                      buildInputLabel('New password', textTh),
                      Gap(height: 5),
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
                      Gap(height: 10),
                      Gap(
                        height: 20,
                      ),
                      CustomButton(
                        isFilledButton: true,
                        buttonWidget: state.apiStatus == ApiState.busy
                            ? InsideButtonCustomCircularLoader()
                            : state.apiStatus == ApiState.error
                                ? Text(
                                    'Retry',
                                    style: textTheme.labelLarge!.copyWith(
                                        letterSpacing: 0.5,
                                        fontFamily: "Inter",
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis),
                                  )
                                : Text(
                                    'Login with new Password',
                                    style: textTheme.labelLarge!.copyWith(
                                        letterSpacing: 0.5,
                                        fontFamily: "Inter",
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                        buttonAction: () async {
                          if (AppKeys.changePasswordFormKey.currentState
                                  ?.validate() ==
                              true) {
                            AppKeys.changePasswordFormKey.currentState!.save();
                            try {
                              changePassController.updateEmail(
                                  widget.forgotPasswordModel.email);
                              ForgotPasswordState result =
                                  await changePassController.changePassword();
                              if (result.responseSuccess) {
                                debugPrint(
                                    "response status of changing password is success.");
                                ref
                                    .read(authStatusProvider.notifier)
                                    .setAuthStatus(AuthStatus.pending);
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
                                  User? user = await SecureStorageService()
                                      .getUserFromStorage();

                                  passwordController.clear();
                                  pinController.clear();

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
