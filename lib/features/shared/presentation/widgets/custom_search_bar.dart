import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final Size size;
  final Function(String?) onChangedCallback;
  final VoidCallback searchCallback;
  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.onChangedCallback,
    required this.searchCallback,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.8,
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
            //color: Colors.grey.shade300,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.mainGrey, width: 2)),
        child: TextField(
          onChanged: onChangedCallback,
          // onSaved: (value) {
          //   onSaved(value!);
          // },
          //keyboardType: keyboardType ?? TextInputType.name,
          //obscureText: obscure ?? false,
          // validator: (value) {
          //   return validator(value!);
          // },

          style: const TextStyle(color: AppColors.mainBlue),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: AppColors.darkerGrey,
              ),
              onPressed: searchCallback,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.darkerGrey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
