import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/subscription/model/bank_info.dart';
import 'package:lms_system/features/subscription/presentation/widgets/courses_subscribe_tab.dart';
import 'package:lms_system/features/subscription/presentation/widgets/exams_subscribe_tab.dart';
import 'package:lms_system/features/subscription/provider/bank_info_provider.dart';

class BankData extends StatelessWidget {
  final String accountNumber, accountName;
  const BankData({
    super.key,
    required this.accountNumber,
    required this.accountName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(accountName),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(accountNumber),
                ),
                IconButton(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: accountNumber,
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
          ),
        ],
      ),
    );
  }
}

class BankPricesWidget extends StatelessWidget {
  final List<BankInfo> infos;
  const BankPricesWidget({
    super.key,
    required this.infos,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...infos.map(
              (bInfo) => BankData(
                  accountNumber: bInfo.bankNumber, accountName: bInfo.bankName),
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
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Subscriptions"),
          centerTitle: true,
          elevation: 5,
          shadowColor: Colors.black87,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          actions: [
            Consumer(
              builder: (context, ref, child) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.info,
                      color: AppColors.mainBlue,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Bank Accounts'),
                            content: ref.watch(bankInfoApiProvider).when(
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.mainBlue,
                                    ),
                                  ),
                                  error: (error, stack) => ErrorWidget(error),
                                  data: (infos) =>
                                      BankPricesWidget(infos: infos),
                                ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Back'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.sizeOf(context).width, 30),
            child: const CustomTabBar(
              tabs: [
                Tab(
                  height: 30,
                  text: "Buy Courses",
                ),
                Tab(
                  height: 30,
                  text: "Buy Exams",
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
