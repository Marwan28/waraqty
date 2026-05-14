import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/app/app_directionality.dart';
import 'package:waraqty/app/app_system_ui.dart';
import 'package:waraqty/core/constants/app_constants.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(AppConstants.appWidth, AppConstants.appHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AnnotatedRegion(
          value: AppSystemUi.overlayStyle,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            theme: AppTheme.lightTheme,
            builder: _appBuilder,
            home: const Scaffold(body: Text(AppStrings.appName)),
          ),
        );
      },
    );
  }

  static Widget _appBuilder(BuildContext context, Widget? child) {
    return AppDirectionality(child: child);
  }
}
