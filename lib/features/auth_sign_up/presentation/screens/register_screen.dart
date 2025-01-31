import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/auth_sign_up/provider/register_controller.dart';

final formKey = GlobalKey<FormState>();

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
                  key: formKey,
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
                        validator: _validateInput,
                        onSaved: (value) {
                          regController.updateEmail(value!);
                        },
                      ),
                      _buildInputLabel('Password', textTh),
                      InputWidget(
                        hintText: 'Password',
                        initialValue: state.password,
                        obscure: true,
                        validator: _validateInput,
                        onSaved: (value) {
                          regController.updatePassword(value!);
                        },
                      ),
                      const SizedBox(height: 10),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState?.validate() == true) {
                              formKey.currentState!.save();
                              try {
                                await regController.registerUser();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      elevation: 4,
                                      backgroundColor: Colors.white,
                                      duration: Duration(seconds: 3),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        //'Registration Successful! Verification link will be sent to your email.',
                                        "Registration Successful",
                                        style: TextStyle(
                                          color: AppColors.mainBlue,
                                        ),
                                      ),
                                    ),
                                  );

                                  Navigator.of(context)
                                      .pushReplacementNamed(Routes.wrapper);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      elevation: 4,
                                      backgroundColor: Colors.white,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        "Registration Failed: $e",
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
                          child: Text(
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
