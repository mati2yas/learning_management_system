import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
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
      appBar: CommonAppBar(titleText: "Edit Password"),
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
                    text: "An Email will be sent to your address at ",
                    style: textTh.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: widget.email,
                    style: textTh.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainBlueLighter,
                    ),
                  ),
                  TextSpan(
                    text:
                        " to verify. After that you can log in with your new password.",
                    style: textTh.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
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
                    Navigator.of(context).pushReplacementNamed(
                      Routes.changePassword,
                      arguments: forgotPassData,
                    );
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
