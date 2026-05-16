import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waraqty/app/my_app.dart';
import 'package:waraqty/features/onboarding/data/datasources/onboarding_local_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final onboardingLocalDataSource = OnboardingLocalDataSource(
    sharedPreferences: sharedPreferences,
  );
  final hasSeenOnboarding = await onboardingLocalDataSource.hasSeenOnboarding();
  runApp(
    MyApp(
      hasSeenOnboarding: hasSeenOnboarding,
      sharedPreferences: sharedPreferences,
    ),
  );
}
