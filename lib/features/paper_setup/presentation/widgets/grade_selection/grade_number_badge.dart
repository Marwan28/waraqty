import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class GradeNumberBadge extends StatelessWidget {
  const GradeNumberBadge({
    super.key,
    required this.number,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String number;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58.w,
      height: 58.w,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        number,
        style: AppTextStyles.titleMedium.copyWith(
          color: foregroundColor,
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
