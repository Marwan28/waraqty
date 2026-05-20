import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/paper_setup/domain/entities/subject_entity.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/subject_selection/available_status.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/subject_selection/subject_icon.dart';

class AvailableSubjectCard extends StatelessWidget {
  const AvailableSubjectCard({
    super.key,
    required this.subject,
    required this.isSelected,
    required this.onTap,
  });

  final SubjectEntity subject;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardColor = isSelected
        ? const Color(AppColors.primarySoft)
        : const Color(AppColors.surface);
    final borderColor = isSelected
        ? const Color(AppColors.primary)
        : const Color(AppColors.border);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: borderColor, width: isSelected ? 1.2.w : 1.w),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Row(
              children: [
                SubjectIcon(isSelected: isSelected),
                SizedBox(width: AppSpacing.lg.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: const Color(AppColors.textPrimary),
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      Text(
                        _questionsBankText(subject),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: const Color(AppColors.textSecondary),
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      AvailableStatus(label: subject.statusLabel),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _questionsBankText(SubjectEntity subject) {
    if (!subject.hasQuestionsCountText) return '';

    return '${subject.questionsCountPrefix} ${subject.questionsCount} ${subject.questionsCountSuffix}';
  }
}
