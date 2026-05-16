import 'package:shared_preferences/shared_preferences.dart';
import 'package:waraqty/core/constants/app_constants.dart';

class OnboardingLocalDataSource {
  late final SharedPreferences sharedPreferences;

  OnboardingLocalDataSource({required this.sharedPreferences});

  Future<bool> hasSeenOnboarding() async {
    try {
      final isFirstTime = sharedPreferences.getBool(
        AppConstants.hasSeenOnboardingKey,
      );
      return isFirstTime ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> setOnboardingSeen() async {
    await sharedPreferences.setBool(AppConstants.hasSeenOnboardingKey, true);
  }
}
