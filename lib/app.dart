import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/features/check_update/model/check_update_model.dart';
import 'package:lms_system/features/check_update/provider/check_update_provider.dart';
import 'package:lms_system/main.dart';

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

    return routesAsync.when(
      loading: () => Container(color: Colors.white),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (routesData) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return MaterialApp(
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: AppColors.mainBlue),
                useMaterial3: true,
              ),
              initialRoute: routesData.firstRoute,
              onGenerateRoute: Approuter.generateRoute,
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
