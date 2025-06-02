import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/auth_status_registration/provider/auth_status_controller.dart';

class AsyncErrorWidget extends StatefulWidget {
  final String errorMsg;
  final Function callback;
  const AsyncErrorWidget({
    super.key,
    required this.errorMsg,
    required this.callback,
  });

  @override
  State<AsyncErrorWidget> createState() => _AsyncErrorWidgetState();
}

class _AsyncErrorWidgetState extends State<AsyncErrorWidget> {
  bool isLoading = false;
  bool isUnathenticated = false;
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
            widget.errorMsg.contains("is not a subtype of")
                ? Text(
                    "Oops, error is from our side, we're working on it.",
                    style: textTh.titleMedium!.copyWith(color: Colors.red),
                  )
                : Text(
                    widget.errorMsg.replaceAll("Exception:", ""),
                    style: textTh.titleMedium!.copyWith(color: Colors.red),
                  ),
            Consumer(
              builder: (context, ref, child) {
                return FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.mainBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (isUnathenticated) {
                      var authStatCtrl = ref.read(authStatusProvider.notifier);
                      authStatCtrl.clearStatus();
                      authStatCtrl.setAuthStatus(AuthStatus.notAuthed);
                      Navigator.of(context).pushReplacementNamed(Routes.signup);
                      return;
                    }
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isUnathenticated = widget.errorMsg.contains("Unauthenticated");
  }
}
