import 'package:flutter/material.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width * 0.6,
      backgroundColor: AppColors.mainBlue,
      elevation: 3,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 128,
              child: Row(
                spacing: 10,
                children: [
                  const SizedBox(
                    height: 75,
                    width: 75,
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/profile_pic.png"),
                      radius: 75,
                    ),
                  ),
                  Text(
                    "Matiyas Seifu",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // const ListTileButton(
            //   iconData: Icons.dark_mode,
            //   titleText: "Dark Mode",
            // ),
            ListTileButton(
              onTap: () {
                //Navigator.of(context).pushNamed(Routes.notifications);
                Navigator.of(context).pushNamed(Routes.login);
              },
              iconData: Icons.notifications_outlined,
              titleText: "Notification",
            ),
            ListTileButton(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.profile);
              },
              iconData: Icons.person_outline,
              titleText: "Profile",
            ),
            ListTileButton(
              onTap: () {},
              iconData: Icons.help_outline,
              titleText: "FAQ",
            ),
            ListTileButton(
              onTap: () {},
              iconData: Icons.phone_outlined,
              titleText: "Contact",
            ),
            ListTileButton(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove("userData");
              },
              iconData: Icons.logout_outlined,
              titleText: "logout",
            ),
          ],
        ),
      ),
    );
  }
}

class ListTileButton extends StatelessWidget {
  final IconData iconData;
  final String titleText;
  final Function onTap;
  const ListTileButton({
    super.key,
    required this.iconData,
    required this.titleText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      leading: Container(
        height: 28,
        width: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Icon(
          iconData,
          color: AppColors.mainBlue,
        ),
      ),
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
      ),
    );
  }
}
