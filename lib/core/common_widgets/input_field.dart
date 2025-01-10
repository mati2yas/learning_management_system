import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/colors.dart';

class InputWidget extends StatelessWidget {
  final Function(String?) onSaved;

  final dynamic Function(String) validator;
  TextInputType? keyboardType;
  final String hintText;
  bool? obscure;
  final String initialValue;
  InputWidget({
    super.key,
    required this.onSaved,
    this.keyboardType,
    required this.hintText,
    required this.validator,
    this.obscure,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          onSaved: onSaved,
          keyboardType: keyboardType ?? TextInputType.name,
          obscureText: obscure ?? false,
          validator: (value) {
            return validator(value!);
          },
          initialValue: initialValue,
          style: const TextStyle(color: AppColors.mainBlue),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.darkerGrey,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
