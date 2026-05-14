import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const String fontFamily = 'IBMPlexSansArabic';

  static TextStyle get displayLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: const Color(AppColors.textPrimary),
    height: 1.25,
  );

  static TextStyle get titleLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: const Color(AppColors.textPrimary),
    height: 1.35,
  );

  static TextStyle get titleMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: const Color(AppColors.textPrimary),
    height: 1.45,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: const Color(AppColors.textPrimary),
    height: 1.65,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: const Color(AppColors.textSecondary),
    height: 1.65,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: const Color(AppColors.textMuted),
    height: 1.5,
  );

  static TextStyle get button => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
    color: const Color(AppColors.white),
    height: 1.3,
  );
}
