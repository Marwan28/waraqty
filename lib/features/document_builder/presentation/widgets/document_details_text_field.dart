import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class DocumentDetailsTextField extends StatelessWidget {
  const DocumentDetailsTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.onChanged,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: const Color(AppColors.primarySoft),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  size: 17.sp,
                  color: const Color(AppColors.primary),
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(AppColors.textPrimary),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            keyboardType: keyboardType,
            maxLines: maxLines,
            textInputAction: maxLines == 1
                ? TextInputAction.next
                : TextInputAction.newline,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(AppColors.textPrimary),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodySmall.copyWith(
                color: const Color(AppColors.textMuted),
              ),
              isDense: true,
              filled: true,
              fillColor: const Color(AppColors.surfaceSoft),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.md.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: const Color(AppColors.primary),
                  width: 1.2.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
