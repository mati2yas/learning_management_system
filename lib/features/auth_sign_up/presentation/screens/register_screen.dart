import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/auth_sign_up/provider/register_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final textTh = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final regController = ref.watch(registerControllerProvider.notifier);
    final state = ref.watch(registerControllerProvider);

    double maxFormWidth = 400;
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures layout adjusts for keyboard
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  maxWidth: maxFormWidth,
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
                          controller: nameController,
                          validator: _validateInput,
                          onSaved: (value) {
                            regController.updateName(value!);
                          },
                        ),
                        _buildInputLabel('Email', textTh),
                        InputWidget(
                          hintText: 'Email',
                          controller: emailController,
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
                            'Password (at least 4 characters)', textTh),
                        InputWidget(
                          hintText: 'Password',
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
                          obscureOption: true,
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
                                      vertical: 10,
                                    ),
                              fixedSize: Size(size.width - 80, 60),
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
                                      UtilFunctions.buildInfoSnackbar(
                                        message:
                                            "Registration Successful. Check your email for verification",
                                      ),
                                    );

                                    nameController.clear();
                                    emailController.clear();
                                    passwordController.clear();

                                    //Navigator.of(context)
                                    //   .pushReplacementNamed(Routes.login);

                                    Navigator.of(context)
                                        .pushNamed(Routes.login);
                                  }
                                } catch (e) {
                                  String exc =
                                      e.toString().replaceAll("Exception:", "");
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      UtilFunctions.buildErrorSnackbar(
                                        errorMessage: "Registration Failed:",
                                        exception: exc,
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
                                        style: textTh.titleLarge!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Register',
                                        style: textTh.titleLarge!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: RichText(
                              textDirection: TextDirection.ltr,
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Already have an account?",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " Sign In",
                                    style: const TextStyle(
                                      color: AppColors.mainBlue2,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final state = ref.watch(registerControllerProvider);
    //   nameController.text = state.name;
    //   emailController.text = state.email;
    //   passwordController.text = state.password;
    // });
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
