import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/core/utils/build_button_label_method.dart';
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Gap(height: 80),
                        Text(
                          'Welcome Aboard, Sign Up',
                          style: textTh.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Gap(height: 25),
                        buildInputLabel('Your Name', textTh),
                        Gap(),
                        InputWidget(
                          hintText: 'Your Name',
                          controller: nameController,
                          validator: _validateInput,
                          onSaved: (value) {
                            regController.updateName(value!);
                          },
                        ),
                        Gap(height: 15),
                        buildInputLabel('Email', textTh),
                        Gap(),
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
                        Gap(height: 15),
                        buildInputLabel('Password', textTh),
                        Gap(),
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
                        Gap(height: 40),
                        CustomButton(
                          isFilledButton: true,
                          buttonWidget: state.apiStatus == ApiState.busy
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
                                      style: textTheme.labelLarge!.copyWith(
                                          letterSpacing: 0.5,
                                          fontFamily: "Inter",
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis),
                                    )
                                  : Text(
                                      'Register',
                                      style: textTheme.labelLarge!.copyWith(
                                          letterSpacing: 0.5,
                                          fontFamily: "Inter",
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                          buttonAction: () async {
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

                                  Navigator.of(context).pushNamed(Routes.login);
                                }
                              } catch (e) {
                                String exc =
                                    e.toString().replaceAll("Exception:", "");
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    UtilFunctions.buildErrorSnackbar(
                                      errorMessage:
                                          "Registration Failed: ${exc.toString().replaceAll("Exception:", "")}",
                                      exception: exc,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        ),
                        Gap(
                          height: 25,
                        ),
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

  String? _validateInput(String value) {
    if (value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }
}
