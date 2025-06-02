import 'package:flutter/gestures.dart';
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
import 'package:lms_system/features/auth_login/provider/login_controller.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loginController = ref.watch(loginControllerProvider.notifier);
    final state = ref.watch(loginControllerProvider);
    final size = MediaQuery.sizeOf(context);

    double maxFormWidth = 400;
    final textTh = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: maxFormWidth,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: AppKeys.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(
                        height: 150,
                      ),
                      Text(
                        'Welcome back, Sign In',
                        style: textTh.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      Gap(
                        height: 30,
                      ),

                      buildInputLabel('Email', textTh),

                      Gap(),
                      InputWidget(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email';
                          }

                          // Regular expression to validate email format
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }

                          return null; // Return null if the input is valid
                        },
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Your Email',
                        onSaved: (value) {
                          loginController.updateEmail(value!);
                        },
                      ),

                      Gap(height: 20),
                      buildInputLabel('PassChange Emailword', textTh),

                      Gap(),
                      InputWidget(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Password";
                          }
                          if (value.length < 4) {
                            return "Password must be at least 4 characters long";
                          }
                          return null;
                        },
                        controller: passwordController,
                        hintText: 'Password',
                        // obscureOption: true,
                        onSaved: (value) {
                          loginController.updatePassword(value!);
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(Routes.forgotPassword);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: textTh.labelLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.mainBlue,
                            ),
                          ),
                        ),
                      ),
                      //const SizedBox(height: 15),

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
                                    'Login',
                                    style: textTheme.labelLarge!.copyWith(
                                        letterSpacing: 0.5,
                                        fontFamily: "Inter",
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                        buttonAction: () async {
                          if (AppKeys.loginFormKey.currentState?.validate() ==
                              true) {
                            AppKeys.loginFormKey.currentState!.save();
                            try {
                              await loginController.loginUser();
                              await SecureStorageService()
                                  .setUserAuthedStatus(AuthStatus.authed);
                              var refreshData =
                                  ref.refresh(currentUserProvider.notifier);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  UtilFunctions.buildInfoSnackbar(
                                      message: "Login Successful"),
                                );
                                User? user = await SecureStorageService()
                                    .getUserFromStorage();

                                await Future.delayed(
                                    const Duration(seconds: 2));
                                emailController.clear();
                                passwordController.clear();

                                debugPrint(
                                    "user loginCount: ${user?.loginCount}");

                                if (context.mounted) {
                                  if ((user?.loginCount ?? 0) > 0) {
                                    Navigator.of(context).pushReplacementNamed(
                                        Routes.wrapper,
                                        arguments:
                                            user?.token ?? "invalidtoken");
                                  } else {
                                    Navigator.of(context).pushReplacementNamed(
                                        Routes.profileAdd);
                                  }
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  UtilFunctions.buildErrorSnackbar(
                                    errorMessage:
                                        "Login Failed: ${e.toString().replaceAll("Exception:", "")}",
                                    exception: e,
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),

                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 80,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: RichText(
                              textDirection: TextDirection.ltr,
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Don't have an account?",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const TextSpan(text: '\t\t'),
                                  TextSpan(
                                    text: "Sign Up",
                                    style: const TextStyle(
                                      color: AppColors.mainBlue2,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                Routes.signup);
                                      },
                                  ),
                                ],
                              ),
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
