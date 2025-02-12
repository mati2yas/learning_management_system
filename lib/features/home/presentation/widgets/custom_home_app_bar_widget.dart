import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/features/requests/provider/requests_provider.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

import '../../../wrapper/presentation/screens/wrapper_screen.dart';

class CustomHomeAppBar extends ConsumerWidget {
  final AsyncValue<User> userState;

  const CustomHomeAppBar({
    super.key,
    required this.userState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var requestsProv = ref.watch(requestsProvider);
    return Container(
      height: 135,
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 47,
                child: GestureDetector(
                  onTap: () {
                    //Scaffold.of(context).openDrawer();
                    Keys.globalkey.currentState!.openDrawer();
                  },
                  child: SvgPicture.asset(
                    "assets/svgs/hamburger_menu.svg",
                  ),
                ),
              ),
              const Spacer(),
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
                    if (requestsProv.isNotEmpty)
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
                            "${requestsProv.length}",
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
          const Text(
            "👋 Hello",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          userState.when(
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
        ],
      ),
    );
  }
}
