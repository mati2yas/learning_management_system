import 'package:flutter/material.dart';
import 'package:lms_system/core/common_widgets/custom_dialog.dart';
import 'package:lms_system/core/constants/app_colors.dart';

Future<dynamic> showContentInaccessibleMessage(BuildContext context) async {
  showCustomDialog(
    context: context,
    title: 'Access Denied ',
    content: Text('Please purchase this course / exam to access the content.',
        textAlign: TextAlign.center),
    onCancel: () => Navigator.pop(context),
    icon: Icons.lock,
    iconColor: primaryColor,
    confirmText: 'Ok',
    cancelText: 'Cancel',
  );
  // showDialog(
  //   context: context,
  //   builder: (context) => AlertDialog(
  //     title: Center(child: const Text('Access Denied !')),
  //     content: const Text(
  //       'Please purchase this course / exam to access the content.',
  //     ),
  //     actions: [
  //       TextButton(
  //         onPressed: () => Navigator.pop(context),
  //         child: const Text('OK'),
  //       ),
  //     ],
  //   ),
  // );
}
