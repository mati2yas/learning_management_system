import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';

class InputWidget extends StatefulWidget {
  final Function(String?) onSaved;
  final Function(String?)? onChanged;

  TextEditingController? controller;
  final dynamic Function(String) validator;
  TextInputType? keyboardType;
  final String hintText;
  String? initialValue;
  bool obscureOption;
  int? maxLines, maxLength;
  final int minLines;
  InputWidget({
    super.key,
    required this.onSaved,
    this.onChanged,
    this.keyboardType,
    required this.hintText,
    required this.validator,
    this.initialValue,
    this.obscureOption = false,
    this.maxLength,
    this.maxLines = 2,
    this.minLines = 1,
    this.controller,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType ?? TextInputType.name,
      obscureText: widget.obscureOption ? false : false,
      controller: widget.controller,
      validator: (value) {
        return widget.validator(value!);
      },
      initialValue: widget.initialValue,
      style: const TextStyle(color: AppColors.mainBlue),
      inputFormatters: [],
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: AppColors.darkerGrey,
          // fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: primaryColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: primaryColor, width: 1),
        ),
      ),
    );
  }
}
