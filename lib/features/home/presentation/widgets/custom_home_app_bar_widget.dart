import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/features/courses/presentation/widgets/search_delegate.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';
import 'package:lms_system/features/subscription/provider/requests/exam_requests_provider.dart';

import '../../../subscription/provider/requests/course_requests_provider.dart';

class CustomHomeAppBar extends ConsumerWidget {
  final AsyncValue<User> userState;

  const CustomHomeAppBar({
    super.key,
    required this.userState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var courseRequestsProv = ref.watch(courseRequestsProvider);
    var examRequestsProv = ref.watch(examRequestsProvider);
    return Container(
      height: 135,
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 5,
            children: [
              SizedBox(
                width: 47,
                child: GestureDetector(
                  onTap: () {
                    AppKeys.drawerKey.currentState!.openDrawer();
                  },
                  child: SvgPicture.asset(
                    "assets/svgs/hamburger_menu.svg",
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.notifications);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CourseSearchDelegate(
                        widgetRef: ref, previousScreenIndex: 0),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.requests);
                },
                child: Stack(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Center(
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                    if (courseRequestsProv.isNotEmpty)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            "${courseRequestsProv.length}",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    if (examRequestsProv.isNotEmpty)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            "${examRequestsProv.length}",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Text(
              "👋 Hello",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: userState.when(
              error: (error, stack) {
                return Text(error.toString());
              },
              loading: () => const Text("Loading User..."),
              data: (user) {
                String name = user.name.replaceAll("\"", "");
                return Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
