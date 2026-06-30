import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/document_builder/domain/entities/saved_pdf_file_entity.dart';

class SavedPdfFileTile extends StatelessWidget {
  const SavedPdfFileTile({
    super.key,
    required this.savedFile,
    required this.onShare,
  });

  final SavedPdfFileEntity savedFile;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: const Color(AppColors.primarySoft),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              LucideIcons.fileCheck2,
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
                  savedFile.file.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(AppColors.textPrimary),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  savedFile.displayPath,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          IconButton(
            onPressed: onShare,
            tooltip: PdfPreviewStrings.share,
            icon: Icon(LucideIcons.share2, size: 20.sp),
            color: const Color(AppColors.primary),
          ),
        ],
      ),
    );
  }
}
