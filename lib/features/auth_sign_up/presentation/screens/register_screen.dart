import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/auth_sign_up/provider/register_controller.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTh = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final regController = ref.watch(registerControllerProvider.notifier);
    final state = ref.watch(registerControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures layout adjusts for keyboard
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: AppKeys.registerScreenKey,
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Welcome Aboard, Sign Up',
                        style: textTh.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      _buildInputLabel('Your Name', textTh),
                      InputWidget(
                        hintText: 'Your Name',
                        initialValue: state.name,
                        validator: _validateInput,
                        onSaved: (value) {
                          regController.updateName(value!);
                        },
                      ),
                      _buildInputLabel('Email', textTh),
                      InputWidget(
                        hintText: 'Email',
                        initialValue: state.email,
                        keyboardType: TextInputType.emailAddress,
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
                        onSaved: (value) {
                          regController.updateEmail(value!);
                        },
                      ),
                      _buildInputLabel(
                          'Password (at least 6 characters)', textTh),
                      InputWidget(
                        hintText: 'Password',
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
                        obscure: true,
                        onSaved: (value) {
                          regController.updatePassword(value!);
                        },
                      ),
                      const SizedBox(height: 10),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (AppKeys.registerScreenKey.currentState
                                    ?.validate() ==
                                true) {
                              AppKeys.registerScreenKey.currentState!.save();
                              try {
                                await regController.registerUser();
                                await SecureStorageService()
                                    .setUserAuthedStatus(AuthStatus.pending);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      elevation: 4,
                                      backgroundColor: Colors.white,
                                      duration: Duration(seconds: 3),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        "Registration Successful. Check your email for verification",
                                        style: TextStyle(
                                          color: AppColors.mainBlue,
                                        ),
                                      ),
                                    ),
                                  );
                                  regController.updateName("");
                                  regController.updateEmail("");
                                  regController.updatePassword("");

                                  Navigator.of(context)
                                      .pushReplacementNamed(Routes.login);
                                }
                              } catch (e) {
                                String exc =
                                    e.toString().replaceAll("Exception:", "");
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      elevation: 4,
                                      backgroundColor: Colors.white,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        "Registration Failed: $exc",
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: state.apiStatus == ApiState.busy
                              ? const Center(
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
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
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Already have an account?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: " Sign In",
                                style: const TextStyle(
                                  color: AppColors.mainBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .pushReplacementNamed(Routes.login);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputLabel(String label, TextTheme textTh) {
    return Text(
      label,
      style: textTh.bodyMedium!.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String? _validateInput(String value) {
    if (value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }
}
