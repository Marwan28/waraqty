import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_radius.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/onboarding/presentation/models/onboarding_page_data.dart';

class OnboardingPageItem extends StatelessWidget {
  const OnboardingPageItem({super.key, required this.data});

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: data.iconBackgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.iconTile.r),
          ),
          child: Icon(data.icon, color: data.iconColor, size: 34.sp),
        ),
        SizedBox(height: 36.h),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.titleLarge,
        ),
        SizedBox(height: 14.h),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
