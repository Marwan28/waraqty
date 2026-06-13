import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class DocumentDetailsFontSizeControl extends StatelessWidget {
  const DocumentDetailsFontSizeControl({
    super.key,
    required this.fontSize,
    required this.onChanged,
  });

  final double fontSize;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(AppColors.primarySoft),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  LucideIcons.slidersHorizontal,
                  color: const Color(AppColors.primary),
                  size: 19.sp,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Text(
                  DocumentDetailsStrings.fontSize,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md.w,
                  vertical: AppSpacing.xs.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(AppColors.primarySoft),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  '${fontSize.round()} ${DocumentDetailsStrings.pixel}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(AppColors.primary),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(AppColors.primary),
              inactiveTrackColor: const Color(AppColors.borderSoft),
              thumbColor: const Color(AppColors.primary),
              overlayColor: const Color(
                AppColors.primary,
              ).withValues(alpha: 0.12),
              trackHeight: 8.h,
            ),
            child: Slider(
              min: 12,
              max: 20,
              divisions: 8,
              value: fontSize,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
