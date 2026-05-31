import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class DocumentSummaryEmptyView extends StatelessWidget {
  const DocumentSummaryEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.screenHorizontalPadding.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: const Color(AppColors.primarySoft),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                LucideIcons.fileQuestion,
                color: const Color(AppColors.primary),
                size: 32.sp,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              DocumentSummaryStrings.noQuestionsTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              DocumentSummaryStrings.noQuestionsSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
