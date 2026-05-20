import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/paper_setup/domain/entities/grade_entity.dart';

class GradeMetaText extends StatelessWidget {
  const GradeMetaText({super.key, required this.grade});

  final GradeEntity grade;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.bodySmall.copyWith(
      color: const Color(AppColors.textSecondary),
      fontSize: 12.5.sp,
      fontWeight: FontWeight.w400,
      height: 1.4,
    );

    return Row(
      children: [
        Icon(
          LucideIcons.bookOpenCheck,
          size: 14.sp,
          color: const Color(AppColors.textSecondary),
        ),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            '${grade.subjectsCount} ${GradeSelectionStrings.availableSubject}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            '•',
            style: style.copyWith(
              color: const Color(AppColors.primary),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Flexible(
          child: Text(
            '${grade.questionsCount} ${GradeSelectionStrings.questions}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}
