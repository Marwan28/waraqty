import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/theme/app_colors.dart';

class PaperSetupBackButton extends StatelessWidget {
  const PaperSetupBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52.w,
      height: 52.w,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          side: BorderSide(color: const Color(AppColors.border), width: 1.w),
          foregroundColor: const Color(AppColors.textPrimary),
          backgroundColor: const Color(AppColors.surface),
        ),
        child: Icon(LucideIcons.chevronRight, size: 22.sp),
      ),
    );
  }
}
