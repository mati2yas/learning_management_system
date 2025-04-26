import 'package:flutter/material.dart';
import 'package:lms_system/app/root_checker.dart';
import 'package:lms_system/features/auth_login/presentation/screens/login_screen.dart';
import 'package:lms_system/features/auth_sign_up/presentation/screens/register_screen.dart';
import 'package:lms_system/features/auth_sign_up/presentation/screens/temporary_screen.dart';
import 'package:lms_system/features/chapter_content/presentation/screens/chapter_content_screen.dart';
import 'package:lms_system/features/courses/presentation/screens/chapter/chapter_videos.dart';
import 'package:lms_system/features/courses/presentation/widgets/search_courses_screen.dart';
import 'package:lms_system/features/courses_filtered/presentation/screens/courses_filter_screen.dart';
import 'package:lms_system/features/edit_profile/presentation/screens/change_email_screen.dart';
import 'package:lms_system/features/edit_profile/presentation/screens/edit_profile_screen.dart';
import 'package:lms_system/features/edit_profile/presentation/screens/forgot_password_profile_screen.dart';
import 'package:lms_system/features/forgot_password/model/forgot_password_model.dart';
import 'package:lms_system/features/forgot_password/presentation/change_password_screen.dart';
import 'package:lms_system/features/forgot_password/presentation/forgot_password_screen.dart';
import 'package:lms_system/features/home/presentation/screens/faq_contact_us.dart';
import 'package:lms_system/features/home/presentation/screens/home_screen.dart';
import 'package:lms_system/features/notification/presentation/screens/notification_screen.dart';
import 'package:lms_system/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:lms_system/features/paid_courses_exams/presentation/screens/bookmarked_courses_screen.dart';
import 'package:lms_system/features/paid_courses_exams/presentation/screens/bookmarked_exams_screen.dart';
import 'package:lms_system/features/profile/presentation/screens/profile_screen.dart';
import 'package:lms_system/features/profile_add/presentation/screens/profile_add_screen.dart';
import 'package:lms_system/features/quiz/model/quiz_model.dart';
import 'package:lms_system/features/quiz/presentation/quiz_questions_screen.dart';
import 'package:lms_system/features/saved/presentation/screens/saved_screen.dart';
import 'package:lms_system/features/subscription/presentation/screens/subscription_screen.dart';
import 'package:lms_system/features/wrapper/presentation/screens/wrapper_screen.dart';

import '../features/courses/presentation/screens/course/courses_screen.dart';
import '../features/shared/model/chapter.dart';

class Approuter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.rootDetection:
        return MaterialPageRoute(
            builder: (_) => const AdvancedRootDetectionScreen());
      case Routes.wrapper:
        return MaterialPageRoute(
          builder: (_) => const WrapperScreen(),
        );

      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.searchScreen:
        return MaterialPageRoute(
          builder: (_) => const SearchCoursesScreen(),
        );
      case Routes.contactUs:
        return MaterialPageRoute(builder: (_) => const ContactUsPage());

      case Routes.faq:
        return MaterialPageRoute(builder: (_) => const FAQPage());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.signup:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case Routes.tempScreen:
        return MaterialPageRoute(builder: (_) => const TemporaryScreen());

      case Routes.profileAdd:
        return MaterialPageRoute(builder: (_) => const ProfileAddScreen());

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case Routes.changePassword:
        final forgotPassModel = settings.arguments as ForgotPasswordModel;
        return MaterialPageRoute(
          builder: (_) => ChangePasswordScreen(
            forgotPasswordModel: forgotPassModel,
          ),
        );
      case Routes.forgotPasswordProfile:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProfileForgotPasswordScreen(email: email),
        );
      case Routes.courses:
        return MaterialPageRoute(builder: (_) => const CoursePage());

      case Routes.subscriptions:
        final tabIndex = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => SubscriptionScreen(
            initialIndex: tabIndex,
          ),
        );
      case Routes.filterCourses:
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

      case Routes.bookmarkedCourses:
        return MaterialPageRoute(
          builder: (_) => const BookmarkedCoursesScreen(),
        );
      case Routes.bookmarkedExams:
        return MaterialPageRoute(
          builder: (_) => const BookmarkedExamsScreen(),
        );
      case Routes.chapterVideo:
        final video = settings.arguments as Video;
        return MaterialPageRoute(
          builder: (_) => ChapterVideoWidget(
            video: video,
          ),
        );
      case Routes.quizQuestions:
        final quiz = settings.arguments as Quiz;
        return MaterialPageRoute(
          builder: (context) => QuizQuestionsPage(quiz: quiz),
        );

      case Routes.savedCourses:
        return MaterialPageRoute(builder: (_) => const SavedCoursesPage());

      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case Routes.profileEdit:
        return MaterialPageRoute<bool>(
          builder: (_) => const EditProfileScreen(),
        );
      case Routes.changeEmail:
        return MaterialPageRoute<bool>(
          builder: (_) => const ChangeEmailScreen(),
        );
      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

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
  static const String rootDetection = '/root_detection';
  static const String wrapper = "wrapper";
  static const String onboarding = "onboarding";
  static const String home = "home";
  static const String searchScreen = "searchScreen";
  static const String contactUs = "contactUs";
  static const String faq = "faq";
  static const String login = "login";
  static const String profileAdd = "profile_add";
  static const String profileEdit = "profile_edit";
  static const String signup = "signup";
  static const String courses = "courses";
  static const String bookmarkedCourses = "bookmarkedCourses";
  static const String bookmarkedExams = "bookmarkedExams";
  static const String filterCourses = "courseDetails";
  static const String chapterContent = "chapterDetails";
  static const String quizQuestions = "quizQuestions";
  static const String savedCourses = "saved";
  static const String subscriptions = "requests";
  static const String profile = "profile";
  static const String notifications = "notifications";
  static const String chapterVideo = "chapterVideo";
  static const String tempScreen = "tempScreen";
  static const String forgotPassword = "forgotPassword";
  static const String forgotPasswordProfile = "forgotPasswordProfile";
  static const String changePassword = "changePassword";
  static const String changeEmail = "changeEmail";
}
