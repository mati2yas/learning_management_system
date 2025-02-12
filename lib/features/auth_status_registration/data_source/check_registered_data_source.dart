
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationStatusDataSource {
  Future<void> clearRegistrationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all registration data
  }

  

  Future<bool> isUserRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userData'); // Check if the token exists
  }
}
