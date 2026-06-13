import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class DocumentDetailsOptionChip extends StatelessWidget {
  const DocumentDetailsOptionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.sm.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(AppColors.primary)
              : const Color(AppColors.surface),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: isSelected
                ? const Color(AppColors.primary)
                : const Color(AppColors.border),
            width: 1.1.w,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected
                ? const Color(AppColors.white)
                : const Color(AppColors.textPrimary),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
