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
import 'package:waraqty/features/document_builder/presentation/cubit/document_details_cubit.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/document_details_bottom_bar.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/document_details_font_size_control.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/document_details_option_chip.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/document_details_overview_card.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/document_details_paper_type_switcher.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/document_details_switch_tile.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/document_details_text_field.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';
import 'package:waraqty/features/paper_setup/presentation/cubit/paper_setup_cubit.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_setup_header.dart';
import 'package:waraqty/features/question_bank/presentation/cubit/question_selection_cubit.dart';

class DocumentDetailsScreen extends StatelessWidget {
  const DocumentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      body: SafeArea(
        child: BlocBuilder<QuestionSelectionCubit, QuestionSelectionState>(
          builder: (context, questionState) {
            final questionCubit = context.read<QuestionSelectionCubit>();
            final selectedPaperType = questionCubit.selectedPaperType;
            final isBooklet = selectedPaperType.type == PaperType.booklet;
            final selectedQuestionsCount = _selectedQuestionsCount(
              questionState,
            );

            return BlocBuilder<DocumentDetailsCubit, DocumentDetailsState>(
              builder: (context, detailsState) {
                final detailsCubit = context.read<DocumentDetailsCubit>();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PaperSetupHeader(
                      step: DocumentDetailsStrings.step5Of5,
                      title: isBooklet
                          ? BookletDetailsStrings.detailsTitle
                          : ExamDetailsStrings.detailsTitle,
                      subtitle: isBooklet
                          ? BookletDetailsStrings.detailsSubtitle
                          : ExamDetailsStrings.detailsSubtitle,
                      onBackPressed: context.pop,
                    ),
                    Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: const Color(AppColors.border),
                    ),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.all(
                          AppSpacing.screenHorizontalPadding.w,
                        ),
                        children: [
                          DocumentDetailsOverviewCard(
                            gradeTitle: questionCubit.selectedGrade.title,
                            subjectTitle: questionCubit.selectedSubject.title,
                            paperTypeTitle: selectedPaperType.title,
                            selectedQuestionsCount: selectedQuestionsCount,
                          ),
                          SizedBox(height: AppSpacing.xl.h),
                          DocumentDetailsPaperTypeSwitcher(
                            paperTypes: context
                                .read<PaperSetupCubit>()
                                .paperTypes,
                            selectedPaperType: selectedPaperType,
                            onChanged: (paperType) =>
                                _changePaperType(context, paperType),
                          ),
                          SizedBox(height: AppSpacing.xl.h),
                          if (isBooklet)
                            _buildBookletForm(
                              detailsCubit,
                              detailsState,
                              questionCubit.selectedSubject.title,
                            )
                          else
                            _buildExamForm(
                              detailsCubit,
                              detailsState,
                              questionCubit.selectedSubject.title,
                            ),
                        ],
                      ),
                    ),
                    DocumentDetailsBottomBar(
                      onPreviewPressed: () =>
                          context.push(AppRoutes.pdfPreview),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _changePaperType(BuildContext context, PaperTypeEntity paperType) {
    context.read<PaperSetupCubit>().selectPaperType(paperType);
    context.read<QuestionSelectionCubit>().changePaperType(paperType);
  }

  Widget _buildBookletForm(
    DocumentDetailsCubit cubit,
    DocumentDetailsState state,
    String subjectTitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(DocumentDetailsStrings.documentData),
        DocumentDetailsTextField(
          label: BookletDetailsStrings.bookletTitle,
          hint: BookletDetailsStrings.bookletTitleHint,
          initialValue: state.bookletTitle,
          onChanged: cubit.updateBookletTitle,
          icon: LucideIcons.fileText,
        ),
        SizedBox(height: AppSpacing.md.h),
        DocumentDetailsTextField(
          label: DocumentDetailsStrings.subjectName,
          hint: DocumentDetailsStrings.subjectNameHint,
          initialValue: state.subjectName.isEmpty
              ? subjectTitle
              : state.subjectName,
          onChanged: cubit.updateSubjectName,
          icon: LucideIcons.bookOpenCheck,
        ),
        SizedBox(height: AppSpacing.xl.h),
        _buildSectionTitle(DocumentDetailsStrings.teacherData),
        DocumentDetailsTextField(
          label: BookletDetailsStrings.teacherName,
          hint: BookletDetailsStrings.teacherNameHint,
          initialValue: state.teacherName,
          onChanged: cubit.updateTeacherName,
          icon: LucideIcons.clipboardPen,
        ),
        SizedBox(height: AppSpacing.md.h),
        DocumentDetailsTextField(
          label: BookletDetailsStrings.teacherPhoneNumber,
          hint: BookletDetailsStrings.teacherPhoneNumberHint,
          initialValue: state.teacherPhoneNumber,
          onChanged: cubit.updateTeacherPhoneNumber,
          keyboardType: TextInputType.phone,
          icon: LucideIcons.clipboardPen,
        ),
        SizedBox(height: AppSpacing.xl.h),
        _buildSectionTitle(DocumentDetailsStrings.layoutSettings),
        _buildTemplatePicker(cubit, state),
        SizedBox(height: AppSpacing.md.h),
        DocumentDetailsFontSizeControl(
          fontSize: state.fontSize,
          onChanged: cubit.updateFontSize,
        ),
        SizedBox(height: AppSpacing.md.h),
        DocumentDetailsSwitchTile(
          title: DocumentDetailsStrings.includeAnswersTitle,
          subtitle: DocumentDetailsStrings.includeAnswersSubtitle,
          value: state.includeBookletAnswers,
          onChanged: cubit.toggleBookletAnswers,
          icon: LucideIcons.checkCheck,
        ),
        SizedBox(height: AppSpacing.xl.h),
      ],
    );
  }

  Widget _buildExamForm(
    DocumentDetailsCubit cubit,
    DocumentDetailsState state,
    String subjectTitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(DocumentDetailsStrings.documentData),
        DocumentDetailsTextField(
          label: ExamDetailsStrings.schoolName,
          hint: ExamDetailsStrings.schoolNameHint,
          initialValue: state.schoolName,
          onChanged: cubit.updateSchoolName,
          icon: LucideIcons.fileText,
        ),
        SizedBox(height: AppSpacing.md.h),
        DocumentDetailsTextField(
          label: ExamDetailsStrings.governorate,
          hint: ExamDetailsStrings.governorateHint,
          initialValue: state.governorate,
          onChanged: cubit.updateGovernorate,
          icon: LucideIcons.fileText,
        ),
        SizedBox(height: AppSpacing.md.h),
        DocumentDetailsTextField(
          label: ExamDetailsStrings.educationalAdministration,
          hint: ExamDetailsStrings.educationalAdministrationHint,
          initialValue: state.educationalAdministration,
          onChanged: cubit.updateEducationalAdministration,
          icon: LucideIcons.fileText,
        ),
        SizedBox(height: AppSpacing.md.h),
        DocumentDetailsTextField(
          label: ExamDetailsStrings.examTitle,
          hint: ExamDetailsStrings.examTitleHint,
          initialValue: state.examTitle,
          onChanged: cubit.updateExamTitle,
          icon: LucideIcons.clipboardPen,
        ),
        SizedBox(height: AppSpacing.md.h),
        DocumentDetailsTextField(
          label: DocumentDetailsStrings.subjectName,
          hint: DocumentDetailsStrings.subjectNameHint,
          initialValue: state.subjectName.isEmpty
              ? subjectTitle
              : state.subjectName,
          onChanged: cubit.updateSubjectName,
          icon: LucideIcons.bookOpenCheck,
        ),
        SizedBox(height: AppSpacing.xl.h),
        _buildSectionTitle(DocumentDetailsStrings.teacherData),
        DocumentDetailsTextField(
          label: ExamDetailsStrings.teacherName,
          hint: ExamDetailsStrings.teacherNameHint,
          initialValue: state.teacherName,
          onChanged: cubit.updateTeacherName,
          icon: LucideIcons.clipboardPen,
        ),
        SizedBox(height: AppSpacing.xl.h),
        _buildSectionTitle(DocumentDetailsStrings.layoutSettings),
        DocumentDetailsTextField(
          label: ExamDetailsStrings.examDuration,
          hint: ExamDetailsStrings.examDurationHint,
          initialValue: state.examDuration,
          onChanged: cubit.updateExamDuration,
          icon: LucideIcons.slidersHorizontal,
        ),
        SizedBox(height: AppSpacing.md.h),
        DocumentDetailsTextField(
          label: ExamDetailsStrings.totalGrade,
          hint: ExamDetailsStrings.totalGradeHint,
          initialValue: state.totalGrade,
          onChanged: cubit.updateTotalGrade,
          keyboardType: TextInputType.number,
          icon: LucideIcons.slidersHorizontal,
        ),
        SizedBox(height: AppSpacing.md.h),
        DocumentDetailsFontSizeControl(
          fontSize: state.fontSize,
          onChanged: cubit.updateFontSize,
        ),
        SizedBox(height: AppSpacing.md.h),
        DocumentDetailsSwitchTile(
          title: DocumentDetailsStrings.answerSpacesTitle,
          subtitle: DocumentDetailsStrings.answerSpacesSubtitle,
          value: state.includeAnswerSpaces,
          onChanged: cubit.toggleAnswerSpaces,
          icon: LucideIcons.checkCheck,
        ),
        SizedBox(height: AppSpacing.xl.h),
      ],
    );
  }

  Widget _buildTemplatePicker(
    DocumentDetailsCubit cubit,
    DocumentDetailsState state,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            BookletDetailsStrings.bookletTemplate,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Wrap(
            spacing: AppSpacing.sm.w,
            runSpacing: AppSpacing.sm.h,
            children: [
              for (final template in BookletDetailsStrings.bookletTemplates)
                DocumentDetailsOptionChip(
                  label: template,
                  isSelected: state.bookletTemplate == template,
                  onTap: () => cubit.updateBookletTemplate(template),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(fontSize: 17.sp),
      ),
    );
  }

  int _selectedQuestionsCount(QuestionSelectionState state) {
    if (state is QuestionSelectionLoaded) {
      return state.selectedQuestionsCount;
    }
    if (state is QuestionSelectionLoading && state.previousState != null) {
      return state.previousState!.selectedQuestionsCount;
    }
    if (state is QuestionSelectionError && state.previousState != null) {
      return state.previousState!.selectedQuestionsCount;
    }
    return 0;
  }
}
