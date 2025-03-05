import 'package:flutter/material.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  List<Widget> bodyWidgets = [];
  int currentWidget = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textTh = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        titleText: "Forgot Password",
      ),
      //body: bodyWidgets[currentWidget],
      body: Column(
        children: [
          Text(
            "Reset Password",
            style: textTh.headlineSmall!.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
