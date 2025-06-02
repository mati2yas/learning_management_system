import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';

class NoDataWidget extends StatefulWidget {
  final String noDataMsg;
  final Function callback;
  const NoDataWidget({
    super.key,
    required this.noDataMsg,
    required this.callback,
  });

  @override
  State<NoDataWidget> createState() => _NoDataWidgetState();
}

class _NoDataWidgetState extends State<NoDataWidget> {
  bool isLoading = false;
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
              widget.noDataMsg,
              textAlign: TextAlign.center,
              style: textTh.bodyLarge!.copyWith(
                color: AppColors.mainBlue,
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.mainBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await widget.callback();
                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }
}
