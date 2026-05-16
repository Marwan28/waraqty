import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/app/app_directionality.dart';
import 'package:waraqty/app/app_system_ui.dart';
import 'package:waraqty/core/constants/app_constants.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/routing/app_router.dart';
import 'package:waraqty/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

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
            routerConfig: AppRouter(hasSeenOnboarding: hasSeenOnboarding).router,
          ),
        );
      },
    );
  }

  static Widget _appBuilder(BuildContext context, Widget? child) {
    return AppDirectionality(child: child);
  }
}
