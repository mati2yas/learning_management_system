import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/features/subscription/presentation/screens/subscription_screen.dart';
import 'package:lms_system/features/subscription/provider/bank_info_provider.dart';

Future<dynamic> showBankInfo(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer(
        builder: (context, ref, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.5,
              child: Material(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: ref.watch(bankInfoApiProvider).when(
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.mainBlue,
                          ),
                        ),
                        error: (error, stack) => AsyncErrorWidget(
                          errorMsg: error.toString(),
                          callback: () async {
                            ref
                                .refresh(bankInfoApiProvider.notifier)
                                .fetchBankInfo();
                          },
                        ),
                        data: (infos) => BankInformationWidget(infos: infos),
                      ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
