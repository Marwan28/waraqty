import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class DocumentDetailsOverviewCard extends StatelessWidget {
  const DocumentDetailsOverviewCard({
    super.key,
    required this.gradeTitle,
    required this.subjectTitle,
    required this.paperTypeTitle,
    required this.selectedQuestionsCount,
  });

  final String gradeTitle;
  final String subjectTitle;
  final String paperTypeTitle;
  final int selectedQuestionsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      decoration: BoxDecoration(
        color: const Color(AppColors.primary),
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.primary).withValues(alpha: 0.18),
            blurRadius: 22.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: const Color(AppColors.white).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              LucideIcons.fileText,
              color: const Color(AppColors.white),
              size: 34.sp,
            ),
          ),
          SizedBox(width: AppSpacing.lg.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paperTypeTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(AppColors.white).withValues(alpha: 0.80),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$selectedQuestionsCount ${DocumentDetailsStrings.question}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: const Color(AppColors.white),
                    fontSize: 30.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$subjectTitle • $gradeTitle',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(AppColors.white).withValues(alpha: 0.82),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
