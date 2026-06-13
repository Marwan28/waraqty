import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';

class DocumentDetailsPaperTypeSwitcher extends StatelessWidget {
  const DocumentDetailsPaperTypeSwitcher({
    super.key,
    required this.paperTypes,
    required this.selectedPaperType,
    required this.onChanged,
  });

  final List<PaperTypeEntity> paperTypes;
  final PaperTypeEntity selectedPaperType;
  final ValueChanged<PaperTypeEntity> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(AppColors.primarySoft),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  LucideIcons.fileCheck,
                  color: const Color(AppColors.primary),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DocumentDetailsStrings.paperType,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      DocumentDetailsStrings.paperTypeSubtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              for (int index = 0; index < paperTypes.length; index++) ...[
                Expanded(child: _buildPaperTypeButton(paperTypes[index])),
                if (index != paperTypes.length - 1)
                  SizedBox(width: AppSpacing.sm.w),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaperTypeButton(PaperTypeEntity paperType) {
    final isSelected = selectedPaperType.id == paperType.id;

    return InkWell(
      onTap: isSelected ? null : () => onChanged(paperType),
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.md.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(AppColors.primary)
              : const Color(AppColors.surfaceSoft),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(AppColors.primary)
                : const Color(AppColors.border),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              paperType.type == PaperType.booklet
                  ? LucideIcons.clipboardList
                  : LucideIcons.clipboardPen,
              size: 17.sp,
              color: isSelected
                  ? const Color(AppColors.white)
                  : const Color(AppColors.primary),
            ),
            SizedBox(width: AppSpacing.sm.w),
            Flexible(
              child: Text(
                paperType.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected
                      ? const Color(AppColors.white)
                      : const Color(AppColors.textPrimary),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
