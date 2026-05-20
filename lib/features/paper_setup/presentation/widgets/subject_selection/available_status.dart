import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';

class AvailableStatus extends StatelessWidget {
  const AvailableStatus({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: const BoxDecoration(
            color: Color(AppColors.success),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: const Color(AppColors.success),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
