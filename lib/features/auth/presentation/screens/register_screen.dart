import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/colors.dart';

import '../../provider/register_controller.dart';
import '../widgets/input_field.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.watch(registerControllerProvider);
    final textTh = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Aboard, Sign Up',
                  style: textTh.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Start learning Now',
                  style: textTh.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 25),
                _buildInputLabel('Your Name', textTh),
                InputWidget(
                  hintText: 'Your Name',
                  validator: _validateInput,
                  onSaved: (value) {
                    ref
                        .read(registerControllerProvider.notifier)
                        .updateName(value);
                  },
                ),
                const SizedBox(height: 15),
                _buildInputLabel('Phone Number', textTh),
                InputWidget(
                  hintText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: _validateInput,
                  onSaved: (value) {
                    ref
                        .read(registerControllerProvider.notifier)
                        .updatePhone(value);
                  },
                ),
                const SizedBox(height: 15),
                _buildInputLabel('Password', textTh),
                InputWidget(
                  hintText: 'Password',
                  obscure: true,
                  validator: _validateInput,
                  onSaved: (value) {
                    ref
                        .read(registerControllerProvider.notifier)
                        .updatePassword(value);
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: textTh.labelMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
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
                    onPressed: () {
                      // Handle register logic
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.profileAdd);
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
                const SizedBox(height: 25),
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
