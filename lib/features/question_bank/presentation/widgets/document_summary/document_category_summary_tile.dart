import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_category_entity.dart';

class DocumentCategorySummaryTile extends StatelessWidget {
  const DocumentCategorySummaryTile({
    super.key,
    required this.category,
    required this.questionsCount,
    this.onEdit,
    this.onDelete,
  });

  final QuestionCategoryEntity category;
  final int questionsCount;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.md.h,
      ),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Row(
        children: [
          // البادج الدائري على اليمين (أول عنصر في RTL)
          _buildCountBadge(questionsCount),
          SizedBox(width: AppSpacing.md.w),
          // النص في الوسط
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 15.sp),
                ),
                SizedBox(height: 3.h),
                Text(
                  '$questionsCount ${QuestionSelectionStrings.questions}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          // أيقونة التعديل فقط على الشمال
          if (onEdit != null)
            _buildIconButton(
              icon: LucideIcons.pencil,
              tooltip: DocumentSummaryStrings.editCategory,
              onPressed: onEdit!,
              color: const Color(AppColors.primary),
              backgroundColor: const Color(AppColors.primarySoft),
            ),
          if (onEdit != null && onDelete != null)
            SizedBox(width: AppSpacing.sm.w),
          if (onDelete != null)
            _buildIconButton(
              icon: LucideIcons.trash2,
              tooltip: DocumentSummaryStrings.removeCategory,
              onPressed: onDelete!,
              color: const Color(AppColors.coral),
              backgroundColor: const Color(AppColors.coralSoft),
            ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required Color color,
    required Color backgroundColor,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(icon, size: 18.sp, color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildCountBadge(int count) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: const BoxDecoration(
        color: Color(0xFFDEF7F4),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$count',
          style: AppTextStyles.titleMedium.copyWith(
            color: const Color(AppColors.primary),
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
