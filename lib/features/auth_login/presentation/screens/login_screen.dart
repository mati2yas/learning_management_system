import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/auth_login/provider/login_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.watch(loginControllerProvider.notifier);
    final state = ref.watch(loginControllerProvider);
    final size = MediaQuery.of(context).size;
    final textTh = Theme.of(context).textTheme;

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome back, Sign In',
                style: textTh.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: size.height * .47,
                width: size.width * .75,
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InputWidget(
                        validator: _validateInput,
                        initialValue: state.email,
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Your Email',
                        onSaved: (value) {
                          loginController.updateEmail(value!);
                        },
                      ),
                      Text(
                        'Password',
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InputWidget(
                        validator: _validateInput,
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
                          onPressed: () {},
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            fixedSize: Size(size.width - 80, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState?.validate() == true) {
                              formKey.currentState!.save();
                              try {
                                await loginController.loginUser();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Login Successfull"),
                                    ),
                                  );
                                  Navigator.of(context)
                                      .pushReplacementNamed(Routes.wrapper);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Login Failed: $e"),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: Text(
                            'Login',
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
    );
  }

  String? _validateInput(String value) {
    if (value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }
}
