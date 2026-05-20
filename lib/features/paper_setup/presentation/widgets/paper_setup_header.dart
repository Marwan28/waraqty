import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_setup_back_button.dart';

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
          if (onBackPressed != null) ...[
            PaperSetupBackButton(onPressed: onBackPressed!),
            SizedBox(width: AppSpacing.lg.w),
          ],
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
        ],
      ),
    );
  }
}
