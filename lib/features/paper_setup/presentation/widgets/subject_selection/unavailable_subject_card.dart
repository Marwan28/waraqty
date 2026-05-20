import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/paper_setup/domain/entities/subject_entity.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/subject_selection/coming_soon_badge.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/subject_selection/dashed_rounded_border_painter.dart';

class UnavailableSubjectCard extends StatelessWidget {
  const UnavailableSubjectCard({super.key, required this.subject});

  final SubjectEntity subject;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: DashedRoundedBorderPainter(
        color: const Color(AppColors.border),
        radius: 22.r,
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: 76.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(AppColors.background),
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Row(
          children: [
            Text(
              subject.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleMedium.copyWith(
                color: const Color(AppColors.textSecondary),
                fontSize: 17.sp,
              ),
            ),
            const Spacer(),
            ComingSoonBadge(label: subject.statusLabel),
          ],
        ),
      ),
    );
  }
}
