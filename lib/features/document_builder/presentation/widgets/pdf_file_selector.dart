import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/document_builder/domain/entities/generated_pdf_file_entity.dart';

class PdfFileSelector extends StatelessWidget {
  const PdfFileSelector({
    super.key,
    required this.files,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<GeneratedPdfFileEntity> files;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (files.length < 2) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontalPadding.w,
        AppSpacing.md.h,
        AppSpacing.screenHorizontalPadding.w,
        AppSpacing.sm.h,
      ),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(AppColors.surfaceSoft),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Row(
        children: [
          for (var index = 0; index < files.length; index++) ...[
            Expanded(child: _buildOption(index)),
            if (index != files.length - 1) SizedBox(width: 4.w),
          ],
        ],
      ),
    );
  }

  Widget _buildOption(int index) {
    final isSelected = index == selectedIndex;
    return InkWell(
      onTap: isSelected ? null : () => onSelected(index),
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(AppColors.primary)
              : const Color(AppColors.transparent),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          files[index].title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected
                ? const Color(AppColors.white)
                : const Color(AppColors.textSecondary),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
