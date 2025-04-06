import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RootCheckerService {
  static const platform = MethodChannel('com.exceletacademy.lms/root_check');
  static Future<bool?> checkRoot() async {
    bool? isRooted;
    try {
      final bool result = await platform.invokeMethod('isDeviceRooted');
      isRooted = result;
    } on PlatformException catch (e) {
      debugPrint("Error checking root status: '${e.message}'");
      isRooted = null;
    }
    return isRooted ?? false;
  }
}
