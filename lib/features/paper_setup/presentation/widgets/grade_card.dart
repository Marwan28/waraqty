import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/paper_setup/domain/entities/grade_entity.dart';

class GradeCard extends StatelessWidget {
  const GradeCard({
    super.key,
    required this.grade,
    required this.isSelected,
    required this.onTap,
  });

  final GradeEntity grade;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cardColor = isSelected
        ? const Color(AppColors.primarySoft)
        : const Color(AppColors.surface);
    final borderColor = isSelected
        ? const Color(AppColors.primary)
        : const Color(AppColors.border);
    final numberBackgroundColor = isSelected
        ? const Color(AppColors.primary)
        : const Color(AppColors.surfaceSoft);
    final numberForegroundColor = isSelected
        ? const Color(AppColors.white)
        : const Color(AppColors.textPrimary);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: borderColor, width: isSelected ? 1.4 : 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 17.h),
            child: Row(
              children: [
                _GradeNumberBadge(
                  number: grade.gradeLevel,
                  backgroundColor: numberBackgroundColor,
                  foregroundColor: numberForegroundColor,
                ),
                SizedBox(width: AppSpacing.lg.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        grade.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: const Color(AppColors.textPrimary),
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      _GradeMetaText(grade: grade),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Icon(
                  LucideIcons.arrowLeft,
                  color: const Color(AppColors.textSecondary),
                  size: 21.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradeMetaText extends StatelessWidget {
  const _GradeMetaText({required this.grade});

  final GradeEntity grade;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.bodySmall.copyWith(
      color: const Color(AppColors.textSecondary),
      fontSize: 12.5.sp,
      fontWeight: FontWeight.w400,
      height: 1.4,
    );

    return Row(
      children: [
        Icon(
          LucideIcons.bookOpenCheck,
          size: 14.sp,
          color: const Color(AppColors.textSecondary),
        ),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            '${grade.subjectsCount} ${GradeSelectionStrings.availableSubject}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            '•',
            style: style.copyWith(
              color: const Color(AppColors.primary),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Flexible(
          child: Text(
            '${grade.questionsCount} ${GradeSelectionStrings.questions}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

class _GradeNumberBadge extends StatelessWidget {
  const _GradeNumberBadge({
    required this.number,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String number;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58.w,
      height: 58.w,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        number,
        style: AppTextStyles.titleMedium.copyWith(
          color: foregroundColor,
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
