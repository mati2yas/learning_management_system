import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/common_widgets/inside_button_custom_circular_loader.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/fonts.dart';
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
      appBar: CommonAppBar(titleText: ""),
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
                      'Please enter your email address below. A verification email will be sent to you to confirm your identity. Once verified, you will be able to reset your password.',
                      style: textTh.bodyLarge!.copyWith(),
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
                                  'Reset Password',
                                  style: textTheme.labelLarge!.copyWith(
                                      letterSpacing: 0.5,
                                      fontFamily: "Inter",
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis),
                                ),
                      buttonAction: () async {
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
                                      "The password reset PIN has been sent to your email successfully. Please check your inbox for the PIN.",
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
