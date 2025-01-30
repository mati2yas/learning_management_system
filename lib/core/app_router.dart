import 'package:flutter/material.dart';
import 'package:lms_system/features/auth_login/presentation/screens/login_screen.dart';
import 'package:lms_system/features/auth_sign_up/presentation/screens/profile_add.dart';
import 'package:lms_system/features/auth_sign_up/presentation/screens/register_screen.dart';
import 'package:lms_system/features/chapter_content/presentation/screens/chapter_content_screen.dart';
import 'package:lms_system/features/courses/presentation/screens/chapter/chapter_videos.dart';
import 'package:lms_system/features/courses_filtered/presentation/screens/courses_filter_screen.dart';
import 'package:lms_system/features/edit_profile/presentation/screens/edit_profile_screen.dart';
import 'package:lms_system/features/home/presentation/screens/home_screen.dart';
import 'package:lms_system/features/notification/presentation/screens/notification_screen.dart';
import 'package:lms_system/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:lms_system/features/profile/presentation/screens/profile_screen.dart';
import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';
import 'package:lms_system/features/saved/presentation/screens/saved_screen.dart';
import 'package:lms_system/features/wrapper/presentation/screens/wrapper_screen.dart';

import '../features/courses/presentation/screens/course/courses_screen.dart';
import '../features/shared/model/chapter.dart';

class Approuter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.wrapper:
        return MaterialPageRoute(builder: (_) => WrapperScreen());

      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.signup:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case Routes.profileAdd:
        return MaterialPageRoute(builder: (_) => const ProfileAddScreen());

      case Routes.courses:
        return MaterialPageRoute(builder: (_) => const CoursePage());

      case Routes.requests:
        return MaterialPageRoute(builder: (_) => const RequestsScreen());
      case Routes.courseDetails:
        final category = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => const CoursesFilterScreen(),
        );
      case Routes.chapterContent:
        final chapter = settings.arguments as Chapter;
        return MaterialPageRoute(
          builder: (_) => ChapterContentScreen(
            chapter: chapter,
          ),
        );

      case Routes.chapterVideo:
        final video = settings.arguments as Video;
        return MaterialPageRoute(
            builder: (_) => ChapterVideoWidget(
                  video: video,
                ));

      case Routes.saved:
        return MaterialPageRoute(builder: (_) => const SavedCoursesPage());

      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case Routes.profileEdit:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      // case Routes.signUp:
      //   final prevRoute = settings.arguments as String;
      //   return MaterialPageRoute(
      //     builder: (_) => SignUpPage(
      //       previousRoute: prevRoute,
      //     ),
      //   );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("No route defined for ${settings.name}"),
            ),
          ),
        );
    }
  }
}

class Routes {
  static const String wrapper = "wrapper";
  static const String onboarding = "onboarding";
  static const String home = "home";
  static const String login = "login";
  static const String profileAdd = "profile_add";
  static const String profileEdit = "profile_edit";
  static const String signup = "signup";
  static const String courses = "courses";
  static const String courseDetails = "courseDetails";
  static const String chapterContent = "chapterDetails";
  static const String saved = "saved";
  static const String requests = "requests";
  static const String profile = "profile";
  static const String notifications = "notifications";
  static const String chapterVideo = "chapterVideo";
}
