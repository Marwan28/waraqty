import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/theme/app_colors.dart';

class SubjectIcon extends StatelessWidget {
  const SubjectIcon({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(AppColors.primary)
            : const Color(AppColors.primarySoft),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        LucideIcons.bookOpenCheck,
        color: isSelected
            ? const Color(AppColors.white)
            : const Color(AppColors.primary),
        size: 28.sp,
      ),
    );
  }
}
