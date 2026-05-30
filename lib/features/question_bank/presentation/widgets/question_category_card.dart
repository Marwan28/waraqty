import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_category_entity.dart';

class QuestionCategoryCard extends StatelessWidget {
  const QuestionCategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.selectedQuestionsCount,
    required this.onTap,
  });

  final QuestionCategoryEntity category;
  final bool isSelected;
  final int selectedQuestionsCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? const Color(AppColors.textPrimary)
        : const Color(AppColors.surface);
    final foregroundColor = isSelected
        ? const Color(AppColors.white)
        : const Color(AppColors.textPrimary);
    final borderColor = isSelected
        ? const Color(AppColors.textPrimary)
        : const Color(AppColors.border);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      constraints: BoxConstraints(minWidth: 76.w, maxWidth: 136.w),
      height: 50.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    category.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (selectedQuestionsCount > 0) ...[
                  SizedBox(width: AppSpacing.sm.w),
                  Container(
                    constraints: BoxConstraints(minWidth: 22.w),
                    height: 22.h,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(AppColors.white)
                          : const Color(AppColors.primarySoft),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      '$selectedQuestionsCount',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(AppColors.primary),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
