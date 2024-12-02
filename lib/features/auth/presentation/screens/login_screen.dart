import 'package:flutter/gestures.dart';
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _key = GlobalKey<FormState>();
//   String name = '', username = '', phone = '', password = '';
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     var textTh = Theme.of(context).textTheme;
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Welcome back, Sign In',
//                 style: textTh.headlineMedium!.copyWith(
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Start learning Now',
//                 style: textTh.titleLarge!.copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 25),
//               SizedBox(
//                 height: size.height * .45,
//                 width: size.width * .75,
//                 child: Form(
//                   key: _key,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Phone Number',
//                         style: textTh.bodyLarge!.copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       InputWidget(
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'enter correct name';
//                           }
//                           return null;
//                         },
//                         keyboardType: TextInputType.phone,
//                         hintText: 'Phone Number',
//                         onSaved: (value) {
//                           setState(() {
//                             phone = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 15),
//                       Text(
//                         'Password',
//                         style: textTh.bodyLarge!.copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       InputWidget(
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'enter correct name';
//                           }
//                           return null;
//                         },
//                         hintText: 'Password',
//                         obscure: true,
//                         onSaved: (value) {
//                           setState(() {
//                             password = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: TextButton(
//                           onPressed: () {},
//                           child: Text(
//                             "Forgot Password?",
//                             style: textTh.labelLarge!.copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.mainBlue,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 35),
//                       Center(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             //backgroundColor: Colors.black,
//                             backgroundColor: AppColors.mainBlue,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 50,
//                               vertical: 15,
//                             ),
//                             fixedSize: Size(size.width * 0.7, 60),
//                             minimumSize: Size(size.width * 0.55, 45),
//                             maximumSize: Size(size.width * 0.75, 80),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onPressed: () {
//                             if (_key.currentState!.validate()) {}
//                           },
//                           child: Text(
//                             'Login',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: size.width * 0.04,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //const SizedBox(height: 30),
//               Align(
//                 alignment: Alignment.center,
//                 child: SizedBox(
//                   height: 80,
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         const TextSpan(
//                           text: "Don't have an account?",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const TextSpan(text: '\t\t'),
//                         TextSpan(
//                           text: "Sign Up",
//                           style: TextStyle(
//                             color: AppColors.mainBlue.withBlue(253),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                           recognizer: TapGestureRecognizer()
//                             ..onTap = () {
//                               Navigator.of(context)
//                                   .pushReplacementNamed(Routes.signup);
//                             },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';

import '../../provider/login_controller.dart';
import '../widgets/input_field.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.watch(loginControllerProvider);
    final size = MediaQuery.of(context).size;
    final textTh = Theme.of(context).textTheme;

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
                style: textTh.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Start learning Now',
                style: textTh.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: size.height * .45,
                width: size.width * .75,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InputWidget(
                        validator: _validateInput,
                        keyboardType: TextInputType.phone,
                        hintText: 'Phone Number',
                        onSaved: (value) {
                          ref
                              .read(loginControllerProvider.notifier)
                              .updatePhone(value);
                        },
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Password',
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InputWidget(
                        validator: _validateInput,
                        hintText: 'Password',
                        obscure: true,
                        onSaved: (value) {
                          ref
                              .read(loginControllerProvider.notifier)
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
                            backgroundColor: AppColors.mainBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            fixedSize: Size(size.width * 0.7, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Perform login logic here
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
                                  .pushReplacementNamed('/signup');
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
