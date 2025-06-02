import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
import 'package:lms_system/features/edit_profile/provider/edit_profile_provider.dart';
import 'package:lms_system/features/forgot_password/provider/forgot_password_provider.dart';

class ProfileForgotPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  const ProfileForgotPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ProfileForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ProfileForgotPasswordScreen> {
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
      appBar: CommonAppBar(titleText: "Change Password"),
      //body: bodyWidgets[currentWidget],
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 30),
        child: Column(
          children: [
            RichText(
              textDirection: TextDirection.ltr,
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "A verification email will be sent to your email to confirm your identity. Once verified, you will be able to reset your password.",
                    style: textTh.bodyLarge!.copyWith(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            CustomButton(
                isFilledButton: true,
                buttonWidget: state.apiStatus == ApiState.error
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
                  final forgotPassData =
                      await forgotPassController.forgotPassword();

                  ref.invalidate(currentUserProvider);
                  ref.invalidate(editProfileProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      UtilFunctions.buildInfoSnackbar(
                        message:
                            "Password Reset Successfully. Check Your Email for PIN.",
                      ),
                    );
                    Navigator.of(context).pushReplacementNamed(
                      Routes.changePassword,
                      arguments: forgotPassData,
                    );
                  }
                }),
            Gap(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .watch(forgotPasswordControllerProvider.notifier)
          .updateEmail(widget.email);
    });
  }
}
