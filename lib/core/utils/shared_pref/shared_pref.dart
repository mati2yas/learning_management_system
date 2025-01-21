import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = jsonDecode(
      prefs.getString("userData") ?? "{\"data\": \"no data\"}",
    );
    return data["token"];
  }
}
