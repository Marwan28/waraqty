import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waraqty/app/app_directionality.dart';
import 'package:waraqty/app/app_system_ui.dart';
import 'package:waraqty/core/ads/ads_cubit.dart';
import 'package:waraqty/core/constants/app_constants.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/routing/app_router.dart';
import 'package:waraqty/core/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  final bool hasSeenOnboarding;
  final SharedPreferences sharedPreferences;
  final AdsCubit adsCubit;

  const MyApp({
    super.key,
    required this.hasSeenOnboarding,
    required this.sharedPreferences,
    required this.adsCubit,
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
    return BlocProvider.value(
      value: widget.adsCubit,
      child: ScreenUtilInit(
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
      ),
    );
  }

  @override
  void dispose() {
    _router.dispose();
    widget.adsCubit.close();
    super.dispose();
  }

  static Widget _appBuilder(BuildContext context, Widget? child) {
    return AppDirectionality(child: child);
  }
}
