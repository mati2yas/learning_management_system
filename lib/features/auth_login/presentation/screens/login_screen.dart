import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/auth_login/provider/login_controller.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.watch(loginControllerProvider.notifier);
    final state = ref.watch(loginControllerProvider);
    final size = MediaQuery.sizeOf(context);
    final textTh = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: AppKeys.loginFormKey,
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, Sign In',
                      style: textTh.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Email',
                      style: textTh.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                      initialValue: state.email,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Your Email',
                      onSaved: (value) {
                        loginController.updateEmail(value!);
                      },
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
                          return "Please Enter Password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters long";
                        }
                        return null;
                      },
                      initialValue: state.password,
                      hintText: 'Password',
                      obscure: true,
                      onSaved: (value) {
                        loginController.updatePassword(value!);
                      },
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.resetPassword);
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
                    const SizedBox(height: 15),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainBlue,
                          padding: state.apiStatus == ApiState.busy
                              ? null
                              : const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 15,
                                ),
                          fixedSize: Size(size.width - 80, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
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
                                  const SnackBar(
                                    elevation: 4,
                                    backgroundColor: Colors.white,
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      "Login Successful",
                                      style:
                                          TextStyle(color: AppColors.mainBlue),
                                    ),
                                  ),
                                );
                                loginController.updateEmail("");
                                loginController.updatePassword("");
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.profileAdd);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                if (e.toString() == "Email not verified") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      elevation: 4,
                                      backgroundColor: Colors.white,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        "Login Failed: $e",
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      elevation: 4,
                                      backgroundColor: Colors.white,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        "Login Failed: $e",
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
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
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * 0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                :  Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * 0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 80,
                        child: RichText(
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
                                  color: AppColors.mainBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .pushReplacementNamed(Routes.signup);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
