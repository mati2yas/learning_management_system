import 'package:shared_preferences/shared_preferences.dart';

class CheckSeenOnboardingDataSource {
  Future<void> clearSeenOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("hasSeenOnboarding") ?? false;
  }

  Future<void> setHasSeenStatusAlready() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("hasSeenOnboarding", true);
  }
}
