import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/document_builder/domain/entities/saved_pdf_file_entity.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/saved_pdf_file_tile.dart';

class PdfSaveResultSheet extends StatelessWidget {
  const PdfSaveResultSheet({
    super.key,
    required this.savedFiles,
    required this.onShare,
    required this.onViewDetails,
  });

  final List<SavedPdfFileEntity> savedFiles;
  final ValueChanged<SavedPdfFileEntity> onShare;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontalPadding.w,
          AppSpacing.lg.h,
          AppSpacing.screenHorizontalPadding.w,
          AppSpacing.xl.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: const Color(AppColors.border),
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            Container(
              width: 64.w,
              height: 64.w,
              decoration: const BoxDecoration(
                color: Color(AppColors.successSoft),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.circleCheckBig,
                color: const Color(AppColors.success),
                size: 32.sp,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              PdfPreviewStrings.savedSuccessfully,
              style: AppTextStyles.titleMedium,
            ),
            SizedBox(height: AppSpacing.xl.h),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: savedFiles.length,
                itemBuilder: (context, index) {
                  final savedFile = savedFiles[index];
                  return SavedPdfFileTile(
                    savedFile: savedFile,
                    onShare: () => onShare(savedFile),
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: AppSpacing.sm.h),
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: FilledButton(
                onPressed: onViewDetails,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(AppColors.primary),
                  foregroundColor: const Color(AppColors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  textStyle: AppTextStyles.button,
                ),
                child: const Text(PdfPreviewStrings.details),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
