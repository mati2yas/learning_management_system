import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/subscription/presentation/widgets/courses_subscribe_tab.dart';
import 'package:lms_system/features/subscription/presentation/widgets/exams_subscribe_tab.dart';

class BankData extends StatelessWidget {
  final String accountNumber;
  const BankData({
    super.key,
    required this.accountNumber,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
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
    );
  }
}

class BankPricesWidget extends StatelessWidget {
  const BankPricesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CBE Account:"),
            BankData(accountNumber: "1000xxxxxxx"),
            Text("Dashen Account:"),
            BankData(accountNumber: "XXX-XXX-X"),
            Text("Abyssinia Account:"),
            BankData(accountNumber: "XXX-XXX-X"),
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
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.mainBlue,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Bank Accounts'),
                          content: const BankPricesWidget(),
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
                  child: const Text("Account Info")),
            )
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
