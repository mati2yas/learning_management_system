import 'package:flutter/material.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/constants/fonts.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;
  final IconData icon;
  final Color iconColor;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.onCancel,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.icon = Icons.info_outline,
    this.iconColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.1),
              radius: 30,
              child: Icon(icon, size: 30, color: iconColor),
            ),
            Gap(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            Gap(height: 12),
            // Text(content, textAlign: TextAlign.center),
            content,
            Gap(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onCancel != null)
                  TextButton(
                    onPressed: onCancel,
                    child: Text(cancelText),
                  ),
                if (onConfirm != null) Spacer(),
                if (onConfirm != null)
                  Expanded(
                    child: CustomButton(
                      
                        isFilledButton: true,
                        buttonHeight: 30,
                        buttonWidth: double.maxFinite,
                        buttonWidget: Text(confirmText,
                            style: textTheme.labelMedium!.copyWith(
                              letterSpacing: 0.5,
                              fontFamily: "Inter",
                              color: Colors.white,
                            )),
                        buttonAction: onConfirm!),
                  )
                // ElevatedButton(
                //   onPressed: onConfirm,
                //   child: Text(confirmText),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  IconData icon = Icons.info_outline,
  Color iconColor = Colors.blue,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
}) {
  showDialog(
    context: context,
    builder: (_) => CustomDialog(
      title: title,
      content: content,
      onConfirm: onConfirm,
      // onCancel: onCancel ?? () => Navigator.of(context).pop(),
      onCancel: onCancel,
      icon: icon,
      iconColor: iconColor,
      confirmText: confirmText,
      cancelText: cancelText,
    ),
  );
}
