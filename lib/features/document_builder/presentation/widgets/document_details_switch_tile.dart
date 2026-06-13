import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/document_details_switch.dart';

class DocumentDetailsSwitchTile extends StatelessWidget {
  const DocumentDetailsSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(AppSpacing.lg.w),
        decoration: BoxDecoration(
          color: value
              ? const Color(AppColors.primarySoft)
              : const Color(AppColors.surface),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: value
                ? const Color(AppColors.primary)
                : const Color(AppColors.border),
            width: 1.2.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: value
                    ? const Color(AppColors.primary)
                    : const Color(AppColors.surfaceSoft),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: value
                    ? const Color(AppColors.white)
                    : const Color(AppColors.primary),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            DocumentDetailsSwitch(value: value),
          ],
        ),
      ),
    );
  }
}
