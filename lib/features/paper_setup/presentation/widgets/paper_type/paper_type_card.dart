import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_type/paper_type_preview.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_type/paper_type_start_action.dart';

class PaperTypeCard extends StatelessWidget {
  const PaperTypeCard({
    super.key,
    required this.paperType,
    required this.isSelected,
    required this.onTap,
  });

  final PaperTypeEntity paperType;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor;
    final softColor = _softColor;
    final cardColor = isSelected ? softColor : const Color(AppColors.surface);
    final borderColor = isSelected
        ? accentColor
        : const Color(AppColors.border);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: borderColor, width: isSelected ? 1.2 : 1),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.black).withValues(alpha: 0.05),
            blurRadius: 16.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
            child: Row(
              children: [
                PaperTypePreview(paperType: paperType),
                SizedBox(width: AppSpacing.xl.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        paperType.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: const Color(AppColors.textPrimary),
                          fontSize: 19.sp,
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      Text(
                        paperType.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: const Color(AppColors.textSecondary),
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      PaperTypeStartAction(color: accentColor),
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

  Color get _accentColor {
    return paperType.type == PaperType.booklet
        ? const Color(AppColors.primary)
        : const Color(AppColors.coral);
  }

  Color get _softColor {
    return paperType.type == PaperType.booklet
        ? const Color(AppColors.primarySoft)
        : const Color(AppColors.coralSoft);
  }
}
