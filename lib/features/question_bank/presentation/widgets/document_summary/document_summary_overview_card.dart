import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class DocumentSummaryOverviewCard extends StatelessWidget {
  const DocumentSummaryOverviewCard({
    super.key,
    required this.gradeTitle,
    required this.subjectTitle,
    required this.paperTypeTitle,
    required this.totalQuestions,
    required this.categoriesCount,
  });

  final String gradeTitle;
  final String subjectTitle;
  final String paperTypeTitle;
  final int totalQuestions;
  final int categoriesCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F5B5B),
            Color(0xFF0A3F3F),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          // الأيقونة الشفافة — right في RTL = الشمال الفعلي (زي الصورة)
          Positioned.directional(
            textDirection: TextDirection.rtl,
            end: -20.w,
            bottom: -30.h,
            child: Icon(
              LucideIcons.fileText,
              size: 130.sp,
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          // المحتوى — end في RTL = اليمين الفعلي
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DocumentSummaryStrings.totalQuestions,
                textAlign: TextAlign.start,
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(AppColors.white).withValues(alpha: 0.8),
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  // "سؤال" أول لأن RTL — الرقم على اليمين
                  Text(
                    DocumentSummaryStrings.question,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(AppColors.white).withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Text(
                    '$totalQuestions',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: const Color(AppColors.white),
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // "موزعة على" ثم العدد — RTL فالأول يظهر على اليمين
                  Text(
                    DocumentSummaryStrings.dividedBy,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(AppColors.white).withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Text(
                    '$categoriesCount ${DocumentSummaryStrings.categories}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(AppColors.white),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
