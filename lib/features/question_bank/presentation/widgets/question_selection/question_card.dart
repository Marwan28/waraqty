import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/enums/question_difficulty.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_entity.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.isSelected,
    required this.canSelect,
    required this.onTap,
  });

  final int questionNumber;
  final QuestionEntity question;
  final bool isSelected;
  final bool canSelect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? const Color(AppColors.primary)
        : const Color(AppColors.border);
    final backgroundColor = isSelected
        ? const Color(AppColors.primarySoft)
        : const Color(AppColors.surface);
    final foregroundColor = canSelect
        ? const Color(AppColors.textPrimary)
        : const Color(AppColors.textMuted);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      opacity: canSelect ? 1 : 0.56,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.3.w : 1.w,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: canSelect ? onTap : null,
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNumberBadge(),
                      SizedBox(width: AppSpacing.md.w),
                      Expanded(
                        child: Text(
                          question.questionText,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: foregroundColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (question.options.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.md.h),
                    _buildOptions(),
                  ],
                  SizedBox(height: AppSpacing.md.h),
                  _buildMetaRow(),
                  if (question.answerText != null &&
                      question.answerText!.trim().isNotEmpty) ...[
                    SizedBox(height: AppSpacing.md.h),
                    _buildAnswer(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Wrap(
      spacing: AppSpacing.sm.w,
      runSpacing: AppSpacing.sm.h,
      children: question.options
          .map((option) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(AppColors.surface),
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(color: const Color(AppColors.borderSoft)),
              ),
              child: Text(
                option,
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(AppColors.textSecondary),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }

  Widget _buildNumberBadge() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 48.w,
      height: 48.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(AppColors.primary)
            : const Color(AppColors.surfaceSoft),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Text(
        '$questionNumber',
        textAlign: TextAlign.center,
        style: AppTextStyles.titleMedium.copyWith(
          color: isSelected
              ? const Color(AppColors.white)
              : const Color(AppColors.textPrimary),
          fontSize: 18.sp,
        ),
      ),
    );
  }

  Widget _buildMetaRow() {
    final difficultyTitle = question.difficulty.title;
    final metaItems = <String>[
      '${QuestionSelectionStrings.difficulty}: $difficultyTitle',
      if (question.unitName != null && question.unitName!.trim().isNotEmpty)
        '${QuestionSelectionStrings.unit}: ${question.unitName}',
      if (question.lessonName != null && question.lessonName!.trim().isNotEmpty)
        '${QuestionSelectionStrings.lesson}: ${question.lessonName}',
    ];

    return Wrap(
      spacing: AppSpacing.sm.w,
      runSpacing: AppSpacing.xs.h,
      children: metaItems
          .map((item) {
            return Text(
              item,
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(AppColors.textMuted),
              ),
            );
          })
          .toList(growable: false),
    );
  }

  Widget _buildAnswer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(AppColors.borderSoft)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.checkCheck,
            color: const Color(AppColors.success),
            size: 16.sp,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Text(
              '${QuestionSelectionStrings.answer}: ${question.answerText}',
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(AppColors.textSecondary),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
