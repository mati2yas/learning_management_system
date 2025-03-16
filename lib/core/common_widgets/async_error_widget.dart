import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';

class AsyncErrorWidget extends StatelessWidget {
  final String errorMsg;
  final Function callback;
  const AsyncErrorWidget({
    super.key,
    required this.errorMsg,
    required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    final textTh = Theme.of(context).textTheme;
    return Center(
      child: SizedBox(
        height: 140,
        width: 300,
        child: Column(
          spacing: 12,
          children: [
            Text(
              errorMsg.replaceAll("Exception:", ""),
              style: textTh.titleMedium!.copyWith(color: Colors.red),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.mainBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await callback();
              },
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }
}
