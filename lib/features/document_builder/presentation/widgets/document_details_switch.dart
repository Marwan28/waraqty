import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waraqty/core/theme/app_colors.dart';

class DocumentDetailsSwitch extends StatelessWidget {
  const DocumentDetailsSwitch({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 54.w,
      height: 32.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: value
            ? const Color(AppColors.primary)
            : const Color(AppColors.surfaceSoft),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Align(
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: const Color(AppColors.white),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(AppColors.black).withValues(alpha: 0.10),
                blurRadius: 7.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
