import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class PaperSetupHeader extends StatelessWidget {
  const PaperSetupHeader({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    this.onBackPressed,
  });

  final String step;
  final String title;
  final String subtitle;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontalPadding.w,
        AppSpacing.xl.h,
        AppSpacing.screenHorizontalPadding.w,
        AppSpacing.xl.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(AppColors.primary),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.titleLarge.copyWith(fontSize: 26.sp),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          if (onBackPressed != null) ...[
            SizedBox(width: AppSpacing.lg.w),
            _PaperSetupBackButton(onPressed: onBackPressed!),
          ],
        ],
      ),
    );
  }
}

class _PaperSetupBackButton extends StatelessWidget {
  const _PaperSetupBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52.w,
      height: 52.w,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          side: const BorderSide(color: Color(AppColors.border)),
          foregroundColor: const Color(AppColors.textPrimary),
          backgroundColor: const Color(AppColors.surface),
        ),
        child: Icon(LucideIcons.chevronLeft, size: 22.sp),
      ),
    );
  }
}
