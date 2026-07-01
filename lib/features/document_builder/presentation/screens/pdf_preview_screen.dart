import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:waraqty/core/ads/ads_cubit.dart';
import 'package:waraqty/core/constants/app_routes.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/document_builder/presentation/cubit/document_builder_cubit.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/pdf_file_selector.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/pdf_preview_bottom_bar.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/pdf_save_result_sheet.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_setup_header.dart';

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      body: SafeArea(
        child: BlocConsumer<DocumentBuilderCubit, DocumentBuilderState>(
          listenWhen: (previous, current) {
            return previous.status != current.status ||
                previous.errorMessage != current.errorMessage;
          },
          listener: _handleStateChange,
          builder: (context, state) {
            if (state.isGenerating ||
                state.status == DocumentBuilderStatus.initial) {
              return _buildLoading();
            }
            if (state.hasGenerationError) {
              return _buildError(context, state.errorMessage);
            }

            final selectedFile = state.selectedFile;
            if (selectedFile == null) {
              return _buildError(context, PdfPreviewStrings.generationError);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaperSetupHeader(
                  step: PdfPreviewStrings.step,
                  title: PdfPreviewStrings.title,
                  subtitle: PdfPreviewStrings.subtitle,
                  onBackPressed: context.pop,
                ),
                Divider(
                  height: 1.h,
                  thickness: 1.h,
                  color: const Color(AppColors.border),
                ),
                PdfFileSelector(
                  files: state.generatedFiles,
                  selectedIndex: state.selectedFileIndex,
                  onSelected: context.read<DocumentBuilderCubit>().selectFile,
                ),
                Expanded(
                  child: PdfPreview(
                    key: ValueKey(selectedFile.fileName),
                    build: (format) async => selectedFile.bytes,
                    initialPageFormat: PdfPageFormat.a4,
                    allowPrinting: false,
                    allowSharing: false,
                    canChangePageFormat: false,
                    canChangeOrientation: false,
                    canDebug: false,
                    useActions: false,
                    dynamicLayout: false,
                    maxPageWidth: 700,
                    pdfFileName: selectedFile.fileName,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md.w,
                      vertical: AppSpacing.sm.h,
                    ),
                    scrollViewDecoration: const BoxDecoration(
                      color: Color(AppColors.surfaceSoft),
                    ),
                    pdfPreviewPageDecoration: BoxDecoration(
                      color: const Color(AppColors.white),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            AppColors.black,
                          ).withValues(alpha: 0.10),
                          blurRadius: 10.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                  ),
                ),
                PdfPreviewBottomBar(
                  isSaving: state.isSaving,
                  canSave: state.canSave,
                  onSave: context.read<DocumentBuilderCubit>().saveAll,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Color(AppColors.primary)),
          SizedBox(height: AppSpacing.lg.h),
          Text(
            PdfPreviewStrings.generating,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.screenHorizontalPadding.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              PdfPreviewStrings.generationError,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall,
            ),
            SizedBox(height: AppSpacing.lg.h),
            FilledButton(
              onPressed: context.read<DocumentBuilderCubit>().generate,
              child: const Text(PdfPreviewStrings.retry),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleStateChange(
    BuildContext context,
    DocumentBuilderState state,
  ) async {
    if (state.isSaved && state.savedFiles.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(PdfPreviewStrings.savedSuccessfully),
          backgroundColor: const Color(AppColors.success),
          behavior: SnackBarBehavior.floating,
        ),
      );
      await context.read<AdsCubit>().registerSuccessfulPdfSave();
      if (!context.mounted) return;
      _showSaveResultSheet(context, state);
      return;
    }

    if (state.errorMessage.isNotEmpty && !state.hasGenerationError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(PdfPreviewStrings.saveError),
          backgroundColor: const Color(AppColors.coral),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSaveResultSheet(BuildContext context, DocumentBuilderState state) {
    final cubit = context.read<DocumentBuilderCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(AppColors.background),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return PdfSaveResultSheet(
          savedFiles: state.savedFiles,
          onShare: (savedFile) => cubit.shareFile(savedFile.file),
          onViewDetails: () {
            Navigator.of(sheetContext).pop();
            context.push(AppRoutes.savedSuccess);
          },
        );
      },
    );
  }
}
