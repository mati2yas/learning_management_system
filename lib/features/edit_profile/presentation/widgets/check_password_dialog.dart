import 'package:flutter/material.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/utils/build_button_label_method.dart';

class CheckPassword extends StatefulWidget {
  final String email, password;

  const CheckPassword({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<CheckPassword> createState() => _CheckPasswordState();
}

class _CheckPasswordState extends State<CheckPassword> {
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final textTh = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputLabel('Current Password', textTh),
        Gap(),
        InputWidget(
          validator: (value) {
            if (value.isEmpty) {
              return "Please Enter Password";
            }
            if (value.length < 4) {
              return "Password must be at least 4 characters long";
            }
            return null;
          },

          controller: _passwordController,
          hintText: 'Current Password',
          // obscureOption: true,
          onSaved: (value) {},
        ),
        Text(
          _errorMessage ?? "",
          style: TextStyle(color: Colors.red),
        ),
        // TextField(
        //   controller: _passwordController,
        //   keyboardType: TextInputType.emailAddress,
        //   obscureText: _obscure,
        //   decoration: InputDecoration(
        //     labelText: 'Your Password',
        //     border: const OutlineInputBorder(),
        //     errorText: _errorMessage,
        //     suffix: IconButton(
        //       onPressed: () {
        //         setState(() {
        //           _obscure = !_obscure;
        //         });
        //       },
        //       icon: Icon(
        //         _obscure ? Icons.visibility : Icons.visibility_off,
        //       ),
        //     ),
        //   ),
        // ),

        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            Spacer(),
            TextButton(
              onPressed: () => _confirmPassword(context),
              child: const Text("Confirm"),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _confirmPassword(BuildContext context) {
    final enteredPassword = _passwordController.text.trim();
    debugPrint("entered: $enteredPassword, current: ${widget.password}");
    if (enteredPassword == widget.password) {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(
        Routes.forgotPasswordProfile,
        arguments: widget.email,
      );
    } else {
      setState(() {
        _errorMessage = "Incorrect Password.";
      });
    }
  }
}
