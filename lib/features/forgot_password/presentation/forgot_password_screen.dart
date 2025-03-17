import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/auth_status_registration/provider/auth_status_controller.dart';
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
      body: Column(
        children: [
          Text(
            "Forgot Password?",
            style: textTh.headlineSmall!.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Enter your email below, and an email will be sent to you to verify. After that you can log in with your new password.',
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
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email address';
              }

              return null; // Return null if the input is valid
            },
            initialValue: state.email,
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
                fixedSize: Size(size.width - 80, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await forgotPassController.forgotPassword();
                ref.read(authStatusProvider.notifier).clearStatus();
                ref
                    .read(authStatusProvider.notifier)
                    .setAuthStatus(AuthStatus.passwordReset);
                ref.invalidate(currentUserProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      elevation: 4,
                      backgroundColor: AppColors.darkerBlue,
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        "Password Reset Successfully.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacementNamed(Routes.login);
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
                      : Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
