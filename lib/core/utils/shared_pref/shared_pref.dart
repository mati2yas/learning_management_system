import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<void> addToDocumentDirs(String documentPath) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> docs = prefs.getStringList("documentPaths") ?? [];
    if (!docs.contains(documentPath)) {
      docs.add(documentPath);
    }
    await prefs.setStringList("documentPaths", docs);
  }

  static Future<bool> checkIfDocPathExists(String documentPath) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> docs = prefs.getStringList("documentPaths") ?? [];
    if (docs.isEmpty) return false;
    return docs.contains(documentPath);
  }

  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = jsonDecode(
      prefs.getString("userData") ?? "{\"data\": \"no data\"}",
    );

    String? token = data["token"];
    if (token != null) {
      token = token.replaceAll("\"", "");
    }
    return token;
  }
}
