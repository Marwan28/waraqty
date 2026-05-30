import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class DocumentSummaryBottomBar extends StatelessWidget {
  const DocumentSummaryBottomBar({
    super.key,
    required this.hasSelectedQuestions,
    required this.onAddCategory,
    this.onContinue,
  });

  final bool hasSelectedQuestions;
  final VoidCallback? onContinue;
  final VoidCallback onAddCategory;

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
          // زرار "بيانات الملف" — يكبر ويتغير لونه لما في أسئلة
          Expanded(
            child: FilledButton(
              onPressed: onContinue,
              style: FilledButton.styleFrom(
                backgroundColor: hasSelectedQuestions
                    ? const Color(AppColors.primary)
                    : const Color(AppColors.border),
                foregroundColor: hasSelectedQuestions
                    ? const Color(AppColors.white)
                    : const Color(AppColors.textMuted),
                disabledBackgroundColor: const Color(AppColors.border),
                disabledForegroundColor: const Color(AppColors.textMuted),
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.r),
                ),
                textStyle: AppTextStyles.button,
              ),
              child: Text(DocumentSummaryStrings.fileData),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          // زرار "إضافة نوع سؤال +"
          OutlinedButton.icon(
            onPressed: onAddCategory,
            icon: Icon(LucideIcons.plus, size: 18.sp),
            label: Text(DocumentSummaryStrings.addQuestionCategory),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(AppColors.textPrimary),
              side: BorderSide(
                color: const Color(AppColors.border),
                width: 1.5.w,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg.w,
                vertical: AppSpacing.md.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999.r),
              ),
              textStyle: AppTextStyles.button,
            ),
          ),
        ],
      ),
    );
  }
}