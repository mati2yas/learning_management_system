import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'core/app_router.dart';
import 'core/constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DisableScreenshots.disable();
  runApp(const ProviderScope(child: MyApp()));
}

class DisableScreenshots {
  static Future<void> disable() async {
    if (Platform.isAndroid) {
      await _disableScreenshotsAndroid();
    } else if (Platform.isIOS) {
      await _disableScreenshotsIOS();
    }
  }

  static Future<void> _disableScreenshotsAndroid() async {
    try {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } on PlatformException catch (e) {
      print("Error disabling screenshots on Android: ${e.message}");
    }
  }

  static Future<void> _disableScreenshotsIOS() async {
    const platform = MethodChannel('disable_screenshots');
    try {
      await platform.invokeMethod('disable');
    } on PlatformException catch (e) {
      print("Error disabling screenshots on iOS: ${e.message}");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainBlue),
        useMaterial3: true,
      ),
      initialRoute: Routes.onboarding,
      onGenerateRoute: Approuter.generateRoute,
    );
  }
}
