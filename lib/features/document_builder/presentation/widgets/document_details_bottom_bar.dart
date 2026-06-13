import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class DocumentDetailsBottomBar extends StatelessWidget {
  const DocumentDetailsBottomBar({
    super.key,
    required this.onPreviewPressed,
    this.isEnabled = true,
  });

  final VoidCallback? onPreviewPressed;
  final bool isEnabled;

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
          iconAlignment: IconAlignment.end,
          onPressed: isEnabled ? onPreviewPressed : null,
          icon: Icon(LucideIcons.arrowLeft, size: 18.sp),
          label: const Text(DocumentDetailsStrings.previewPdf),
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
