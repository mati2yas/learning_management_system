import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/shared_course/model/shared_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = User(
    name: "Matu",
    lastName: "Sala",
    email: "matusala@gmail.com",
    password: "12343",
    bio:
        "Explorer of life's wonders | Coffee enthusiast ☕ | Aspiring [Your Profession] | 🌍 Traveler | Cat lover 🐾 | Sharing my journey and thoughts. Let's connect!",
    image: "matusala.png",
  );
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Profile"),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height * 0.25,
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 30,
                      sigmaY: 30,
                      tileMode: TileMode.clamp,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: Image.asset(
                        width: size.width,
                        height: size.height * 0.18,
                        "assets/images/web_design.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: size.width * 0.5 -
                        (50 +
                            12), // 50 for radius of circle and 12 for the padding of screen on left
                    child: const CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/web_design.png"),
                      radius: 50,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: size.width * 0.5,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.mainGrey,
                        foregroundColor: Colors.black,
                        iconSize: 24,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.image),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "${user.name} ${user.lastName}",
                style: textTh.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                user.email,
                style: textTh.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user.bio,
              style: textTh.bodyMedium!.copyWith(
                color: AppColors.mainGrey,
              ),
            ),
            const SizedBox(height: 28),
            TextButton.icon(
              onPressed: () {},
              label: Text(
                "Edit Profile",
                style: textTh.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon((Icons.edit)),
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text(
                "Notification",
                style: textTh.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon((Icons.notifications)),
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text(
                "My Exam",
                style: textTh.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon((Icons.pending)),
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text(
                "My Education",
                style: textTh.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon((Icons.school)),
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text(
                "Logout",
                style: textTh.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              icon: const Icon(
                (Icons.logout),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
