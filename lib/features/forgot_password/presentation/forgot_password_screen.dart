import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
import 'package:lms_system/features/forgot_password/provider/forgot_password_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  List<Widget> bodyWidgets = [];
  int currentWidget = 0;
  final TextEditingController emailController = TextEditingController();

  double maxFormWidth = 400;

  @override
  Widget build(BuildContext context) {
    final forgotPassController =
        ref.watch(forgotPasswordControllerProvider.notifier);
    final state = ref.watch(forgotPasswordControllerProvider);
    final size = MediaQuery.sizeOf(context);
    final textTh = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(titleText: "Forgot Password?"),
      //body: bodyWidgets[currentWidget],
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: maxFormWidth,
              ),
              child: Form(
                key: AppKeys.forgotPasswordFormKey,
                child: Column(
                  children: [
                    Text(
                      'Enter your email below, and an email will be sent to you to verify. After that you can log in with your new password.',
                      style: textTh.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 22),
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
                        forgotPassController.updateEmail(value!);
                      },
                    ),
                    const SizedBox(height: 20),
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
                          fixedSize: Size(
                            size.width - 80,
                            65,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (AppKeys.forgotPasswordFormKey.currentState
                                  ?.validate() ==
                              true) {
                            AppKeys.forgotPasswordFormKey.currentState!.save();
                            try {
                              final forgotPassData =
                                  await forgotPassController.forgotPassword();

                              ref.invalidate(currentUserProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  UtilFunctions.buildInfoSnackbar(
                                    message:
                                        "Password Reset Successfully. Check Your Email for PIN.",
                                  ),
                                );
                                emailController.clear();
                                Navigator.of(context).pushReplacementNamed(
                                  Routes.changePassword,
                                  arguments: forgotPassData,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  UtilFunctions.buildErrorSnackbar(
                                      errorMessage:
                                          "Forgot Password Failed: ${UtilFunctions.stripExceptionLabel(e)}",
                                      exception: e),
                                );
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
                                    'Reset Password',
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
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.watch(forgotPasswordControllerProvider);
      emailController.text = state.email;
    });
  }
}
