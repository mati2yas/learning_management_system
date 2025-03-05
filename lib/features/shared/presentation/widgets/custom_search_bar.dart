import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final Size size;
  const CustomSearchBar({
    super.key,
    required this.hintText,
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
        child: TextFormField(
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
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.darkerGrey,
            ),
            suffixIcon: const Icon(
              Icons.menu,
              color: AppColors.darkerGrey,
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
