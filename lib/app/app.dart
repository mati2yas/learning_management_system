import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/root_checker.dart';
import 'package:lms_system/features/auth_status_registration/provider/auth_status_controller.dart';
import 'package:lms_system/features/check_seen_onboarding/provider/check_seen_onboarding_provider.dart';
import 'package:lms_system/features/check_update/model/check_update_model.dart';
import 'package:lms_system/features/check_update/provider/check_update_provider.dart';
import 'package:lms_system/features/shared/model/start_routes.dart';
import 'package:lms_system/features/shared/provider/start_routes_provider.dart';

final initialRouteProvider = FutureProvider<StartRoutes>(
  (ref) async {
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
  },
);

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  late final ProviderSubscription _updateListener;

  @override
  Widget build(BuildContext context) {
    final routesAsync = ref.watch(initialRouteProvider);

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
      super.didChangeAppLifecycleState(state);
      switch (state) {
        case AppLifecycleState.resumed:
          // App is in the foreground, refresh data or re-initialize.
          // Example:
          // ref.read(myAppStateProvider.notifier).loadState();
          break;
        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
          // App is in the background, save critical state.
          // Example:
          // ref.read(myAppStateProvider.notifier).saveState();
          break;
        case AppLifecycleState.detached:
          // The app is about to be terminated.  Do minimal cleanup.
          break;
        case AppLifecycleState.hidden:
          // The application is running in the background but is not
          // visible and not interacting with the user.
          break;
      }
    }

    return routesAsync.when(
      loading: () => Container(color: Colors.white),
      error: (error, stackTrace) => Directionality(
          textDirection: TextDirection.ltr, child: Text('Error: $error')),
      data: (routesData) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return MaterialApp(
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: AppColors.mainBlue),
                useMaterial3: true,
              ),
              debugShowCheckedModeBanner: false,
              onGenerateRoute: Approuter.generateRoute,
              initialRoute: routesData.firstRoute,
              // onGenerateInitialRoutes: (initialRouteName) {
              //   if (initialRouteName == Routes.wrapper) {
              //     const token =
              //         "some_token_here"; // Load it from somewhere like SharedPrefs
              //     return [
              //       MaterialPageRoute(
              //         builder: (_) => const WrapperScreen(apiToken: token),
              //         settings: const RouteSettings(name: Routes.wrapper),
              //       ),
              //     ];
              //   }
              //   return [
              //     Approuter.generateRoute(RouteSettings(name: initialRouteName))
              //   ];
              // },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _updateListener.close(); // Clean up the listener
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _updateListener = ref.listenManual<AsyncValue<AppUpdateStatus>>(
      appUpdateStatusProvider,
      (previous, next) {
        next.whenOrNull(data: (status) {
          ref.read(updateNotifierProvider.notifier).checkForUpdates(context);
        });
      },
    );
  }
}
