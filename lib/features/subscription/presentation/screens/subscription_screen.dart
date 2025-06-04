import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/core/constants/status_bar_styles.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/subscription/model/bank_info.dart';
import 'package:lms_system/features/subscription/presentation/widgets/courses_subscribe_tab.dart';
import 'package:lms_system/features/subscription/presentation/widgets/exams_subscribe_tab.dart';

class BankInfoTile extends StatelessWidget {
  final BankInfo bankInfo;
  const BankInfoTile({
    super.key,
    required this.bankInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      margin: EdgeInsets.only(top: 5),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankInfo.bankName,
                  style: textTheme.labelLarge!.copyWith(
                    letterSpacing: 0.5,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  bankInfo.accountName,
                  style: textTheme.labelMedium!.copyWith(
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  bankInfo.accountNumber,
                  style: textTheme.bodyMedium!.copyWith(
                    letterSpacing: 0.5,
                    color: Colors.black,
                  ),
                ),
                // ListTile(
                //   title: Text(bankInfo.accountNumber),
                //   subtitle: Column(
                //     children: [
                //       Text(bankInfo.bankName),
                //       Text(bankInfo.accountName),
                //     ],
                //   ),
                //   trailing: IconButton(
                //     onPressed: () async {
                //       await Clipboard.setData(
                //         ClipboardData(
                //           text: bankInfo.accountNumber,
                //         ),
                //       );
                //     },
                //     icon: const Icon(
                //       Icons.copy,
                //       color: AppColors.mainBlue,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(
                  text: bankInfo.accountNumber,
                ),
              );
            },
            icon: const Icon(
              Icons.copy,
              color: AppColors.mainBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class BankInformationWidget extends StatelessWidget {
  final List<BankInfo> infos;
  const BankInformationWidget({
    super.key,
    required this.infos,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Payment Options",
                style: textTheme.titleLarge!.copyWith(
                    letterSpacing: 0.5,
                    fontFamily: "Inter",
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            Divider(
              color: primaryColor,
              thickness: 1,
            ),
            ...infos.map(
              (bInfo) => BankInfoTile(
                bankInfo: bInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionScreen extends StatelessWidget {
  final int initialIndex;
  const SubscriptionScreen({
    super.key,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(lightAppBarSystemOverlayStyle);
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Cart",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          elevation: 5,
          shadowColor: Colors.black87,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.sizeOf(context).width, 30),
            child: const CustomTabBar(
              tabs: [
                Tab(
                  height: 30,
                  text: "Course Cart",
                ),
                Tab(
                  height: 30,
                  text: "Exam Cart",
                ),
              ],
              alignment: TabAlignment.fill,
              isScrollable: false,
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            CoursesSubscribePage(),
            ExamsSubscribePage(),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
