import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_type/paper_type_preview_badge.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_type/paper_type_preview_line.dart';

class PaperTypePreview extends StatelessWidget {
  const PaperTypePreview({super.key, required this.paperType});

  final PaperTypeEntity paperType;

  @override
  Widget build(BuildContext context) {
    final accentColor = paperType.type == PaperType.booklet
        ? const Color(AppColors.primary)
        : const Color(AppColors.coral);
    final softColor = paperType.type == PaperType.booklet
        ? const Color(AppColors.primarySoft)
        : const Color(AppColors.coralSoft);

    return SizedBox(
      width: 92.w,
      height: 110.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 86.w,
              height: 104.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: softColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: accentColor.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PaperTypePreviewLine(color: accentColor, height: 6.h),
                  SizedBox(height: 12.h),
                  PaperTypePreviewLine(
                    color: const Color(AppColors.textMuted),
                    height: 5.h,
                    opacity: 0.45,
                  ),
                  SizedBox(height: 8.h),
                  PaperTypePreviewLine(
                    color: const Color(AppColors.textMuted),
                    height: 4.h,
                    opacity: 0.45,
                  ),
                  SizedBox(height: 8.h),
                  PaperTypePreviewLine(
                    color: const Color(AppColors.textMuted),
                    height: 4.h,
                    widthFactor: 0.82,
                    opacity: 0.45,
                  ),
                  SizedBox(height: 8.h),
                  PaperTypePreviewLine(
                    color: const Color(AppColors.textMuted),
                    height: 4.h,
                    widthFactor: 0.7,
                    opacity: 0.45,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: PaperTypePreviewBadge(paperType: paperType),
          ),
        ],
      ),
    );
  }
}
