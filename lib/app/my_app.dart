import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waraqty/app/app_directionality.dart';
import 'package:waraqty/app/app_system_ui.dart';
import 'package:waraqty/core/constants/app_constants.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/routing/app_router.dart';
import 'package:waraqty/core/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  final bool hasSeenOnboarding;
  final SharedPreferences sharedPreferences;

  const MyApp({
    super.key,
    required this.hasSeenOnboarding,
    required this.sharedPreferences,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter(
      hasSeenOnboarding: widget.hasSeenOnboarding,
      sharedPreferences: widget.sharedPreferences,
    ).router;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(AppConstants.appWidth, AppConstants.appHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AnnotatedRegion(
          value: AppSystemUi.overlayStyle,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            theme: AppTheme.lightTheme,
            builder: _appBuilder,
            routerConfig: _router,
          ),
        );
      },
    );
  }

  static Widget _appBuilder(BuildContext context, Widget? child) {
    return AppDirectionality(child: child);
  }
}
