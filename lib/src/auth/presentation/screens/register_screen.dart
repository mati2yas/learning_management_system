import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lms_system/core/app_router.dart';

import '../../../../core/constants/colors.dart';
import '../widgets/input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();
  String name = '', username = '', phone = '', password = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
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
                'Welcome Aboard, Sign Up',
                style: textTh.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Start learning Now',
                style: textTh.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: size.height * .5,
                width: size.width * .75,
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Name',
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InputWidget(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'enter correct name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        hintText: 'Your Name',
                        onSaved: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Phone Number',
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InputWidget(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'enter correct name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        hintText: 'Phone Number',
                        onSaved: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Password',
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // const SizedBox(height: 12),
                      // InputWidget(
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       return 'enter correct name';
                      //     }
                      //     return null;
                      //   },
                      //   hintText: 'Password',
                      //   obscure: true,
                      //   onSaved: (value) {
                      //     setState(() {
                      //       password = value;
                      //     });
                      //   },
                      // ),
                      // const SizedBox(height: 20),
                      // Text(
                      //   'Confirm Password',
                      //   style: textTh.bodyLarge!.copyWith(
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      // const SizedBox(height: 12),
                      // InputWidget(
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       return 'enter correct name';
                      //     }
                      //     return null;
                      //   },
                      //   keyboardType: TextInputType.phone,
                      //   hintText: 'Phone Number',
                      //   onSaved: (value) {
                      //     setState(() {
                      //       phone = value;
                      //     });
                      //   },
                      // ),
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
                      const SizedBox(height: 35),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //backgroundColor: Colors.black,
                            backgroundColor: AppColors.mainBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            fixedSize: Size(size.width * 0.7, 60),
                            minimumSize: Size(size.width * 0.55, 45),
                            maximumSize: Size(size.width * 0.75, 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            //if (_key.currentState!.validate()) {}
                            print("hhh");
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
                    ],
                  ),
                ),
              ),
              //const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 60,
                  child: RichText(
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
                        const TextSpan(text: '\t\t'),
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            color: AppColors.mainBlue.withBlue(253),
                            fontWeight: FontWeight.w600,
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
    );
  }
}
