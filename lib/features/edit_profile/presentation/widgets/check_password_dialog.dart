import 'package:flutter/material.dart';
import 'package:lms_system/core/app_router.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _passwordController,
          keyboardType: TextInputType.emailAddress,
          obscureText: _obscure,
          decoration: InputDecoration(
            labelText: 'Your Password',
            border: const OutlineInputBorder(),
            errorText: _errorMessage,
            suffix: IconButton(
              onPressed: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
              icon: Icon(
                _obscure ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
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
