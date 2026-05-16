import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_radius.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class OnboardingActionButton extends StatelessWidget {
  const OnboardingActionButton({super.key,
    required this.isLastPage,
    required this.onPressed,
  });

  final bool isLastPage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isLastPage
        ? const Color(AppColors.primary)
        : const Color(AppColors.white);
    final foregroundColor = isLastPage
        ? const Color(AppColors.white)
        : const Color(AppColors.primary);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.button.r),
        border: Border.all(color: const Color(AppColors.primary), width: 1.2),
        boxShadow: isLastPage
            ? [
          BoxShadow(
            color: const Color(AppColors.primary).withValues(alpha: 0.16),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ]
            : null,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button.r),
            ),
            side: const BorderSide(color: Color(AppColors.primary), width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isLastPage
                    ? OnboardingStrings.startNow
                    : OnboardingStrings.next,
                style: AppTextStyles.button.copyWith(color: foregroundColor),
              ),
              if (isLastPage) ...[
                SizedBox(width: 8.w),
                Icon(LucideIcons.sparkles, size: 18.sp, color: foregroundColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}