import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class PdfPreviewBottomBar extends StatelessWidget {
  const PdfPreviewBottomBar({
    super.key,
    required this.isSaving,
    required this.canSave,
    required this.onSave,
  });

  final bool isSaving;
  final bool canSave;
  final VoidCallback onSave;

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
      child: SizedBox(
        height: 56.h,
        child: FilledButton.icon(
          onPressed: canSave && !isSaving ? onSave : null,
          icon: isSaving
              ? SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(AppColors.white),
                  ),
                )
              : Icon(LucideIcons.download, size: 19.sp),
          label: Text(
            isSaving ? PdfPreviewStrings.saving : PdfPreviewStrings.save,
          ),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(AppColors.primary),
            disabledBackgroundColor: const Color(AppColors.border),
            foregroundColor: const Color(AppColors.white),
            disabledForegroundColor: const Color(AppColors.textMuted),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999.r),
            ),
            textStyle: AppTextStyles.button,
          ),
        ),
      ),
    );
  }
}
