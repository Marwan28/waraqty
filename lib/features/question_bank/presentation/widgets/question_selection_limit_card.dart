import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_category_entity.dart';

class QuestionSelectionLimitCard extends StatelessWidget {
  const QuestionSelectionLimitCard({
    super.key,
    required this.selectedCategory,
    required this.selectedQuestionsCount,
    required this.questionsCount,
    required this.limit,
    required this.onDecreaseLimit,
    required this.onIncreaseLimit,
    required this.onSetDefaultLimit,
    required this.onSetUnlimited,
    required this.onSelectAll,
    required this.onClearCategory,
  });

  final QuestionCategoryEntity selectedCategory;
  final int selectedQuestionsCount;
  final int questionsCount;
  final int? limit;
  final VoidCallback onDecreaseLimit;
  final VoidCallback onIncreaseLimit;
  final VoidCallback onSetDefaultLimit;
  final VoidCallback onSetUnlimited;
  final VoidCallback onSelectAll;
  final VoidCallback onClearCategory;

  @override
  Widget build(BuildContext context) {
    final isUnlimited = limit == null;
    final progress = questionsCount == 0
        ? 0.0
        : (selectedQuestionsCount / questionsCount).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: const Color(AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.black).withValues(alpha: 0.05),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      QuestionSelectionStrings.categoryTarget,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(AppColors.textSecondary),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      selectedCategory.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 22.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: const Color(AppColors.primarySoft),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  LucideIcons.slidersHorizontal,
                  color: const Color(AppColors.primary),
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoundActionButton(
                icon: LucideIcons.plus,
                onTap: onIncreaseLimit,
              ),
              SizedBox(width: AppSpacing.lg.w),
              _buildLimitBadge(
                text: isUnlimited
                    ? QuestionSelectionStrings.unlimited
                    : '$limit ${QuestionSelectionStrings.questions}',
              ),
              SizedBox(width: AppSpacing.lg.w),
              _buildRoundActionButton(
                icon: LucideIcons.minus,
                onTap: isUnlimited || limit! <= 1 ? null : onDecreaseLimit,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10.h,
              color: const Color(AppColors.primary),
              backgroundColor: const Color(AppColors.borderSoft),
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              Text(
                '$selectedQuestionsCount ${QuestionSelectionStrings.selected} من $questionsCount ${QuestionSelectionStrings.questions}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(AppColors.textSecondary),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _buildUnlimitedSwitch(
                isUnlimited: isUnlimited,
                onTap: isUnlimited ? onSetDefaultLimit : onSetUnlimited,
              ),
              SizedBox(width: AppSpacing.sm.w),
              Flexible(
                child: Text(
                  QuestionSelectionStrings.unlimited,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(AppColors.textPrimary),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: questionsCount == 0 ? null : onSelectAll,
                  icon: Icon(LucideIcons.checkCheck, size: 16.sp),
                  label: const Text(QuestionSelectionStrings.selectAll),
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerRight,
                    foregroundColor: const Color(AppColors.primary),
                    textStyle: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: selectedQuestionsCount == 0 ? null : onClearCategory,
                icon: Icon(LucideIcons.trash2, size: 15.sp),
                label: const Text(QuestionSelectionStrings.clearCategory),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(AppColors.textMuted),
                  disabledForegroundColor: const Color(AppColors.border),
                  textStyle: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundActionButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 54.w,
      height: 54.w,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          backgroundColor: const Color(AppColors.surface),
          foregroundColor: const Color(AppColors.textPrimary),
          disabledForegroundColor: const Color(AppColors.textMuted),
          side: BorderSide(color: const Color(AppColors.border), width: 1.w),
        ),
        child: Icon(icon, size: 20.sp),
      ),
    );
  }

  Widget _buildLimitBadge({required String text}) {
    return Container(
      constraints: BoxConstraints(minWidth: 92.w),
      height: 54.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
      decoration: BoxDecoration(
        color: const Color(AppColors.primarySoft),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppTextStyles.titleMedium.copyWith(
          color: const Color(AppColors.primary),
          fontSize: 18.sp,
        ),
      ),
    );
  }

  Widget _buildUnlimitedSwitch({
    required bool isUnlimited,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 54.w,
        height: 32.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isUnlimited
              ? const Color(AppColors.primarySoft)
              : const Color(AppColors.surfaceSoft),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: const Color(AppColors.border)),
        ),
        child: Align(
          alignment: isUnlimited ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: isUnlimited
                  ? const Color(AppColors.primary)
                  : const Color(AppColors.white),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(AppColors.black).withValues(alpha: 0.08),
                  blurRadius: 6.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
