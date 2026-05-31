import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class QuestionSelectionErrorView extends StatelessWidget {
  const QuestionSelectionErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontalPadding.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: const Color(AppColors.coralSoft),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                LucideIcons.circleAlert,
                color: const Color(AppColors.coral),
                size: 34.sp,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              QuestionSelectionStrings.errorTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppSpacing.xl.h),
            FilledButton.icon(
              onPressed: onRetry,
              icon: Icon(LucideIcons.refreshCw, size: 17.sp),
              label: const Text(QuestionSelectionStrings.retry),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(AppColors.primary),
                foregroundColor: const Color(AppColors.white),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl.w,
                  vertical: AppSpacing.md.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.r),
                ),
                textStyle: AppTextStyles.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
