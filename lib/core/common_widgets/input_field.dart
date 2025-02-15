import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/colors.dart';

class InputWidget extends StatefulWidget {
  final Function(String?) onSaved;

  final dynamic Function(String) validator;
  TextInputType? keyboardType;
  final String hintText;
  final String initialValue;
  bool obscure;
  int? maxLines, maxLength;
  InputWidget({
    super.key,
    required this.onSaved,
    this.keyboardType,
    required this.hintText,
    required this.validator,
    required this.initialValue,
    this.obscure = false,
    this.maxLength,
    this.maxLines,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            onSaved: widget.onSaved,
            keyboardType: widget.keyboardType ?? TextInputType.name,
            obscureText: widget.obscure ? isObscured : false,
            validator: (value) {
              return widget.validator(value!);
            },
            initialValue: widget.initialValue,
            style: const TextStyle(color: AppColors.mainBlue),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: AppColors.darkerGrey,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              suffix: widget.obscure
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isObscured = !isObscured;
                        });
                      },
                      icon: Icon(
                        isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
