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
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width * 0.8,
        constraints: BoxConstraints(maxWidth: 500, maxHeight: 150),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: primaryColor,
              width: 1,
            )),
        child: SingleChildScrollView(
          child: Column(
            spacing: 12,
            children: [
              Text(
                widget.errorMsg.replaceAll('Exception:', ""),
                textAlign: TextAlign.center,
                maxLines: 3,
                style: textTh.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                    overflow: TextOverflow.ellipsis),
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
                        var authStatCtrl =
                            ref.read(authStatusProvider.notifier);
                        authStatCtrl.clearStatus();
                        authStatCtrl.setAuthStatus(AuthStatus.notAuthed);
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.signup);
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
                            strokeWidth: 2,
                          )
                        : const Text("Try Again"),
                  );
                },
              ),
            ],
          ),
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
