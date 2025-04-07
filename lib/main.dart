import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/app.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/root_checker.dart';
import 'package:lms_system/features/auth_status_registration/provider/auth_status_controller.dart';
import 'package:lms_system/features/check_seen_onboarding/provider/check_seen_onboarding_provider.dart';
import 'package:lms_system/features/shared/model/start_routes.dart';
import 'package:lms_system/features/shared/provider/start_routes_provider.dart';
import 'package:lms_system/firebase_options.dart';

import 'core/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

final initialRouteProvider = FutureProvider<StartRoutes>((ref) async {
  final checkSeenOnboardingController =
      ref.watch(checkSeenOnboardingControllerProvider.notifier);
  final checkAuthedController = ref.watch(authStatusProvider.notifier);
  final rootCheckResult = await RootCheckerService.checkRoot();

  bool hasSeenOnboarding =
      await checkSeenOnboardingController.checkSeenOnboarding();
  AuthStatus authStat = await checkAuthedController.checkAuthStatus();
  String firstRoute = Routes.onboarding;
  String secondRoute = Routes.signup;

  if ([true, null].contains(rootCheckResult)) {
    firstRoute = Routes.rootDetection;
    secondRoute = Routes.rootDetection;
  } else if (hasSeenOnboarding) {
    switch (authStat) {
      case AuthStatus.authed:
        firstRoute = Routes.wrapper;
        break;
      case AuthStatus.pending:
        firstRoute = Routes.login;
        secondRoute = Routes.wrapper;
        break;
      case AuthStatus.notAuthed:
        firstRoute = Routes.signup;
        secondRoute = Routes.wrapper;
        break;
    }
  }

  ref.read(startRoutesProvider.notifier).changeRoute(
        firstRoute: firstRoute,
        secondRoute: secondRoute,
      );
  return StartRoutes(
    firstRoute: firstRoute,
    secondRoute: secondRoute,
  );
});
