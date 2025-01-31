import 'package:flutter/material.dart';

class TemporaryScreen extends StatefulWidget {
  const TemporaryScreen({super.key});

  @override
  State<TemporaryScreen> createState() => _TemporaryScreenState();
}

class _TemporaryScreenState extends State<TemporaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 300,
          height: 200,
          child: Column(
            spacing: 10,
            children: [
              const Text(
                  "Verification Code Sent To Your Email. Please check your email."),
              FilledButton(onPressed: () {}, child: const Text(""))
            ],
          ),
        ),
      ),
    );
  }
}
