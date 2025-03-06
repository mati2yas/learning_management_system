import 'package:flutter/material.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/subscription/presentation/widgets/courses_subscribe_tab.dart';
import 'package:lms_system/features/subscription/presentation/widgets/exams_subscribe_tab.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscriptions"),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.sizeOf(context).width, 30),
          child: CustomTabBar(
            controller: _tabController,
            tabs: const [
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
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
}
