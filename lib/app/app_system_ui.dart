import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';

class AppSystemUi {
  static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
    statusBarColor: Color(AppColors.background),
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Color(AppColors.background),
    systemNavigationBarDividerColor: Color(AppColors.background),
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );
}
