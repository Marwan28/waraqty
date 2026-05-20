import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';

class PaperTypePreviewBadge extends StatelessWidget {
  const PaperTypePreviewBadge({super.key, required this.paperType});

  final PaperTypeEntity paperType;

  @override
  Widget build(BuildContext context) {
    final color = paperType.type == PaperType.booklet
        ? const Color(AppColors.primary)
        : const Color(AppColors.coral);

    return Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(AppColors.surface), width: 3),
      ),
      alignment: Alignment.center,
      child: Icon(
        paperType.type == PaperType.booklet
            ? LucideIcons.clipboardList
            : LucideIcons.clipboardPen,
        color: const Color(AppColors.white),
        size: 18.sp,
      ),
    );
  }
}
