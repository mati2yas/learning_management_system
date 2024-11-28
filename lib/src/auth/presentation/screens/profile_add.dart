import 'package:flutter/material.dart';
import 'package:lms_system/core/app_router.dart';

import '../../../../core/constants/colors.dart';
import '../widgets/input_field.dart';

class ProfileAddScreen extends StatefulWidget {
  const ProfileAddScreen({super.key});

  @override
  State<ProfileAddScreen> createState() => _ProfileAddScreenState();
}

class _ProfileAddScreenState extends State<ProfileAddScreen> {
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
                'Welcome Abebe',
                style: textTh.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Let's complete your profile",
                style: textTh.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: size.height * .45,
                width: size.width * .75,
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bio',
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
                        hintText: 'tell Us About Yourself',
                        onSaved: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Email',
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
                        hintText: 'Email',
                        onSaved: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
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
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.wrapper);
                      },
                      child: Text(
                        "Skip",
                        style: textTh.bodyLarge!.copyWith(
                          color: AppColors.mainBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //backgroundColor: Colors.black,
                        backgroundColor: AppColors.mainBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 15,
                        ),
                        fixedSize: const Size(140, 50),
                        minimumSize: const Size(100, 40),
                        maximumSize: const Size(180, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        //if (_key.currentState!.validate()) {}
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.profileAdd);
                      },
                      child: Text(
                        'Submit',
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
