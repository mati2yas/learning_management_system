import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/app/app.dart';
import 'package:lms_system/core/constants/app_colors.dart';

import 'package:lms_system/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: primaryColor, // Transparent status bar
    statusBarIconBrightness: Brightness.light, // White icons
    statusBarBrightness: Brightness.dark, // For iOS
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(
    const ProviderScope(child: MyApp()),
  );
}
