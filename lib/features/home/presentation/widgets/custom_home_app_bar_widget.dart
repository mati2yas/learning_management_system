import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

import '../../../wrapper/presentation/screens/wrapper_screen.dart';

class CustomHomeAppBar extends StatelessWidget {
  final User user;

  const CustomHomeAppBar({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
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
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
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
          Text(
            "${user.name} ${user.lastName}",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
