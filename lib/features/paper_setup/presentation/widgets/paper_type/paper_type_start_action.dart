import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class PaperTypeStartAction extends StatelessWidget {
  const PaperTypeStartAction({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          PaperTypesStrings.start,
          style: AppTextStyles.bodyLarge.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        SizedBox(width: 6.w),
        Icon(LucideIcons.arrowLeft, color: color, size: 18.sp),
      ],
    );
  }
}
