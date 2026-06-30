import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_routes.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/document_builder/presentation/cubit/document_builder_cubit.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/saved_pdf_file_tile.dart';

class SavedSuccessScreen extends StatelessWidget {
  const SavedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      body: SafeArea(
        child: BlocBuilder<DocumentBuilderCubit, DocumentBuilderState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(AppSpacing.screenHorizontalPadding.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IconButton(
                      onPressed: context.pop,
                      icon: Icon(LucideIcons.chevronRight, size: 24.sp),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  Container(
                    width: 86.w,
                    height: 86.w,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(AppColors.successSoft),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.circleCheckBig,
                      color: const Color(AppColors.success),
                      size: 44.sp,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  Text(
                    PdfPreviewStrings.savedSuccessfully,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleLarge,
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    PdfPreviewStrings.savedLocation,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium,
                  ),
                  SizedBox(height: AppSpacing.xxl.h),
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.savedFiles.length,
                      itemBuilder: (context, index) {
                        final savedFile = state.savedFiles[index];
                        return SavedPdfFileTile(
                          savedFile: savedFile,
                          onShare: () => context
                              .read<DocumentBuilderCubit>()
                              .shareFile(savedFile.file),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSpacing.md.h),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  SizedBox(
                    height: 54.h,
                    child: FilledButton(
                      onPressed: () => context.go(AppRoutes.gradeSelection),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(AppColors.primary),
                        foregroundColor: const Color(AppColors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                      child: const Text(PdfPreviewStrings.createNew),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  SizedBox(
                    height: 50.h,
                    child: OutlinedButton(
                      onPressed: context.pop,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(AppColors.primary),
                        side: const BorderSide(color: Color(AppColors.border)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        textStyle: AppTextStyles.button.copyWith(
                          color: const Color(AppColors.primary),
                        ),
                      ),
                      child: const Text(PdfPreviewStrings.backToPreview),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
