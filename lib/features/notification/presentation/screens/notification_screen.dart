import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/notification/model/notification_model.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:number_pagination/number_pagination.dart';

import '../../provider/notification_provider.dart';

//

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int lowestPage = 0, highestPage = 3;

  int lowestPageLimit = 0, highestPageLimit = 10;
  int currentPage = 2;
  String increaseStr = "increase", decreaseStr = "decrease";
  String oneStep = "oneStep", jumpStep = "jumpStep", step = "oneStep";
  @override
  Widget build(BuildContext context) {
    final apiState = ref.watch(notificationApiProvider);
    final notifsController = ref.watch(notificationApiProvider.notifier);
    var size = MediaQuery.of(context).size;
    final notificationState = ref.watch(notificationApiProvider);
    final isLoading =
        ref.watch(notificationApiProvider.select((state) => state.isLoading));
    final notificationData = ref.watch(notificationApiProvider).valueOrNull;
    final totalPages = notificationData?.totalPages ?? 10;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Notifications"),
          centerTitle: true,
          elevation: 5,
          shadowColor: Colors.black87,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          bottom: const PreferredSize(
            preferredSize: Size(double.infinity, 30),
            child: CustomTabBar(tabs: [
              Tab(
                height: 30,
                text: "Unread",
              ),
              Tab(
                height: 30,
                text: "Read",
              )
            ], isScrollable: false),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Unread notifications
                Column(
                  children: [
                    Expanded(
                      child: apiState.when(
                        loading: () => SizedBox(
                          height: size.height * 0.7,
                          width: size.width,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (error, stack) => AsyncErrorWidget(
                          errorMsg: error.toString(),
                          callback: () async {
                            await notifsController.fetchNotifs(
                                page: currentPage, type: NotifType.unread);
                          },
                        ),
                        data: (notifs) {
                          return _buildNotificationList(
                              notifs.unreadNotifs, NotifType.unread, ref);
                        },
                      ),
                    ),
                    if (notificationData != null)
                      NumberPagination(
                        selectedButtonColor: AppColors.mainBlue,
                        buttonRadius: 6,
                        onPageChanged: (number) {
                          setState(() {
                            currentPage = number;
                          });
                        },
                        totalPages: 10,
                        currentPage: currentPage,
                        visiblePagesCount: 4,
                      ),
                  ],
                ),
                // Read notifications
                Column(
                  children: [
                    Expanded(
                      child: apiState.when(
                        loading: () => SizedBox(
                          height: size.height * 0.7,
                          width: size.width,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (error, stack) => AsyncErrorWidget(
                            errorMsg: error.toString(),
                            callback: () async {
                              await notifsController.fetchNotifs(
                                  page: currentPage, type: NotifType.unread);
                            }),
                        data: (notifs) {
                          return _buildNotificationList(
                              notifs.readNotifs, NotifType.read, ref);
                        },
                      ),
                    ),
                    if (notificationData != null)
                      NumberPagination(
                        selectedButtonColor: AppColors.mainBlue,
                        buttonRadius: 6,
                        onPageChanged: (number) {
                          setState(() {
                            currentPage = number;
                          });
                        },
                        totalPages: 10,
                        currentPage: currentPage,
                        visiblePagesCount: 4,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      ref.read(notificationApiProvider.notifier).fetchNotifs(
          page: 1,
          type: _tabController.index == 0 ? NotifType.unread : NotifType.read);
    });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(notificationApiProvider.notifier)
          .fetchNotifs(page: 1, type: NotifType.unread);
    });
  }

  void setPages(
    int newPage,
    String change,
    String step,
  ) {
    setState(() {
      if (step == jumpStep) {
        currentPage = newPage;
        lowestPage = newPage - 1;
        highestPage = newPage + 2;
        // if (lowestPage < lowestPageLimit) {
        //   lowestPage = lowestPageLimit;
        //   highestPage = lowestPageLimit + 3;
        // }
        // if (highestPage > highestPageLimit) {
        //   highestPage = highestPageLimit;
        //   lowestPage = highestPageLimit - 3;
        // }
      } else if (change == increaseStr) {
        if (highestPage < highestPageLimit) {
          lowestPage++;
          highestPage++;
          currentPage = lowestPage;
        }
      } else if (change == decreaseStr) {
        if (lowestPage > lowestPageLimit) {
          lowestPage--;
          highestPage--;
          currentPage = lowestPage;
        }
      }
    });

    debugPrint(
      "current page: $currentPage, lowest page: $lowestPage, highestpage: $highestPage",
    );
  }

  // void setPages(
  //   int newPage,
  //   String change,
  //   String step,
  // ) {
  //   if (step == jumpStep) {
  //     setState(() {
  //       currentPage = newPage;
  //     });
  //     return;
  //   }
  //   if (change == increaseStr) {
  //     setState(() {
  //       if (highestPage <= highestPageLimit) {
  //         int highestPagePrev = highestPage;
  //         int lowestPagePrev = lowestPage;
  //         lowestPage++;
  //         highestPage++;
  //         currentPage = lowestPage;
  //         if (currentPage == highestPagePrev &&
  //             highestPagePrev <= highestPageLimit) {
  //           currentPage = lowestPage;
  //         } else if (currentPage == lowestPagePrev &&
  //             lowestPagePrev >= lowestPageLimit) {
  //           currentPage = lowestPage;
  //         }
  //       }
  //     });
  //     debugPrint(
  //         "increase, current page: $currentPage, lowest page: $lowestPage, highestpage: $highestPage");
  //   } else if (change == decreaseStr) {
  //     setState(() {
  //       if (lowestPage < lowestPageLimit) {
  //         int lowestPagePrev = lowestPage;
  //         int highestPagePrev = highestPage;
  //         lowestPage--;
  //         highestPage--;
  //         if (currentPage == lowestPagePrev &&
  //             lowestPagePrev >= lowestPageLimit) {
  //           currentPage = highestPage;
  //         } else if (currentPage == highestPagePrev &&
  //             highestPagePrev <= highestPageLimit) {
  //           currentPage = highestPage;
  //         }
  //       }
  //       if (newPage > lowestPageLimit) {}
  //     });

  //     debugPrint(
  //         "increase, current page: $currentPage, lowest page: $lowestPage, highestpage: $highestPage");
  //   }
  // }

  Widget _buildNotificationList(
      List<NotificationData> notifications, NotifType type, WidgetRef ref) {
    return ListView.separated(
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return ListTile(
          leading: const Icon(Icons.notifications_outlined,
              color: AppColors.mainBlue, size: 30),
          title: Text(notification.title),
          subtitle: Text(notification.content),
          trailing: PopupMenuButton<void>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) {
              return <PopupMenuEntry<void>>[
                PopupMenuItem<void>(
                  onTap: () async {
                    await ref
                        .read(notificationApiProvider.notifier)
                        .markAsRead(notification);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.mark_as_unread),
                    title: Text("Mark As Read"),
                  ),
                ),
              ];
            },
          ),
        );
      },
    );
  }

  Widget _buildPageNumber({
    required String number,
    required Function callback,
  }) {
    return GestureDetector(
      onTap: () async {
        await callback();
      },
      child: Container(
        margin: const EdgeInsetsDirectional.symmetric(
          horizontal: 10,
        ),
        height: 50,
        width: 30,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: AppColors.mainBlue,
          ),
          borderRadius: BorderRadius.circular(12),
          color: int.parse(number) == currentPage
              ? AppColors.mainBlue.withAlpha(100)
              : Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: const TextStyle(
            color: AppColors.mainBlue,
          ),
        ),
      ),
    );
  }
}
