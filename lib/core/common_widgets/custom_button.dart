import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.isFilledButton,
      required this.buttonWidget,
      required this.buttonAction,
      this.buttonWidth = double.infinity,
      this.buttonHeight = 50});

  final bool isFilledButton;
  final Widget buttonWidget;
  final VoidCallback buttonAction;
  final double buttonWidth;
  final double buttonHeight;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      focusColor: const Color.fromARGB(255, 203, 203, 203),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  isFilledButton ? primaryColor : mainBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                  side: BorderSide(color: primaryColor))),
          onPressed: buttonAction,
          child: Container(
            height: buttonHeight,
            width: buttonWidth, // will be parameter
            child: Center(
              child: buttonWidget,

              // child: Text(
              //     style: textTheme.labelMedium!.copyWith(
              //         letterSpacing: 0.5,
              //         fontFamily: "Inter",
              //         color: isFilledButton ? Colors.white : primaryColor,
              //         overflow: TextOverflow.ellipsis),
              //     buttonLabel),
            ),
          )),
    );
  }
}
