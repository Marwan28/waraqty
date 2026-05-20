import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/paper_setup/domain/entities/grade_entity.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/grade_selection/grade_meta_text.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/grade_selection/grade_number_badge.dart';

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
        border: Border.all(color: borderColor, width: isSelected ? 1.4.w : 1.w),
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
                GradeNumberBadge(
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
                      GradeMetaText(grade: grade),
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
