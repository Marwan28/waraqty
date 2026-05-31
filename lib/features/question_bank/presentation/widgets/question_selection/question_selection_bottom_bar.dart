import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class QuestionSelectionBottomBar extends StatelessWidget {
  const QuestionSelectionBottomBar({
    super.key,
    required this.selectedQuestionsCount,
    required this.canContinue,
    required this.onClearAll,
    required this.onContinue,
  });

  final int selectedQuestionsCount;
  final bool canContinue;
  final VoidCallback onClearAll;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontalPadding.w,
        AppSpacing.md.h,
        AppSpacing.screenHorizontalPadding.w,
        AppSpacing.md.h,
      ),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        border: Border(
          top: BorderSide(color: const Color(AppColors.border), width: 1.w),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildDraftPill()),
          SizedBox(width: AppSpacing.md.w),
          SizedBox(
            height: 56.h,
            child: FilledButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: canContinue ? onContinue : null,
              icon: Icon(LucideIcons.arrowLeft, size: 18.sp),
              label: const Text(QuestionSelectionStrings.continueButton),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(
                  AppColors.primary,
                ),
                    // .withValues(alpha: 0.42),
                disabledBackgroundColor: const Color(AppColors.border),
                foregroundColor: const Color(AppColors.white),
                disabledForegroundColor: const Color(AppColors.textMuted),
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
                textStyle: AppTextStyles.button,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraftPill() {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: const Color(0xFF041313),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: Color(0xFF162626),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.clipboardList,
              color: const Color(AppColors.white),
              size: 20.sp,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  QuestionSelectionStrings.draft,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(AppColors.textMuted),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$selectedQuestionsCount ${QuestionSelectionStrings.questions}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(AppColors.white),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (canContinue)
            IconButton(
              onPressed: onClearAll,
              icon: Icon(LucideIcons.trash2, size: 17.sp),
              color: const Color(AppColors.coral),
              tooltip: QuestionSelectionStrings.clearAll,
            ),
        ],
      ),
    );
  }
}
