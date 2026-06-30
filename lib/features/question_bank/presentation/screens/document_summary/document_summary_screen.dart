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
import 'package:waraqty/features/question_bank/presentation/widgets/document_summary/document_category_summary_tile.dart';
import 'package:waraqty/features/question_bank/presentation/widgets/document_summary/document_summary_bottom_bar.dart';
import 'package:waraqty/features/question_bank/presentation/widgets/document_summary/document_summary_empty_view.dart';
import 'package:waraqty/features/question_bank/presentation/widgets/document_summary/document_summary_overview_card.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_setup_header.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_category_entity.dart';
import 'package:waraqty/features/question_bank/presentation/cubit/question_selection_cubit.dart';

class DocumentSummaryScreen extends StatelessWidget {
  const DocumentSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      body: SafeArea(
        child: BlocBuilder<QuestionSelectionCubit, QuestionSelectionState>(
          builder: (context, questionState) {
            final loadedState = _getLoadedState(questionState);
            final hasSelectedQuestions =
                loadedState != null &&
                loadedState.allSelectedQuestions.isNotEmpty;

            return Column(
              children: [
                PaperSetupHeader(
                  step: DocumentSummaryStrings.summaryStep,
                  title: DocumentSummaryStrings.summaryTitle,
                  subtitle: DocumentSummaryStrings.summarySubtitle,
                  onBackPressed: () => context.pop(),
                ),
                Divider(
                  height: 1.h,
                  thickness: 1.h,
                  color: const Color(AppColors.border),
                ),
                if (!hasSelectedQuestions)
                  const Expanded(child: DocumentSummaryEmptyView())
                else
                  Expanded(child: _buildContent(context, loadedState)),
                DocumentSummaryBottomBar(
                  hasSelectedQuestions: hasSelectedQuestions,
                  onContinue: hasSelectedQuestions
                      ? () => context.push(
                          context
                                      .read<QuestionSelectionCubit>()
                                      .selectedPaperType
                                      .id ==
                                  'booklet'
                              ? AppRoutes.bookletDetails
                              : AppRoutes.examDetails,
                        )
                      : null,
                  onAddCategory: () => context.pop(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  QuestionSelectionLoaded? _getLoadedState(QuestionSelectionState state) {
    if (state is QuestionSelectionLoaded) return state;
    if (state is QuestionSelectionLoading) return state.previousState;
    if (state is QuestionSelectionError) return state.previousState;
    return null;
  }

  Widget _buildContent(BuildContext context, QuestionSelectionLoaded state) {
    final cubit = context.read<QuestionSelectionCubit>();
    final selectedCategories = state.selectedCategories;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(AppSpacing.screenHorizontalPadding.w),
      children: [
        DocumentSummaryOverviewCard(
          gradeTitle: cubit.selectedGrade.title,
          subjectTitle: cubit.selectedSubject.title,
          paperTypeTitle: cubit.selectedPaperType.title,
          totalQuestions: state.selectedQuestionsCount,
          categoriesCount: selectedCategories.length,
        ),
        SizedBox(height: AppSpacing.xl.h),
        Text(
          DocumentSummaryStrings.selectedCategories,
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: AppSpacing.md.h),
        if (selectedCategories.length > 1)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md.h),
            child: Row(
              children: [
                Icon(
                  LucideIcons.move,
                  size: 16.sp,
                  color: const Color(AppColors.textMuted),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  'اسحب لإعادة الترتيب',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (int oldIndex, int newIndex) {
            cubit.reorderSelectedCategory(
              oldIndex: oldIndex,
              newIndex: newIndex,
            );
          },
          proxyDecorator: (child, index, animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final scale = 1.0 + (animation.value * 0.03);
                return Transform.scale(
                  scale: scale,
                  child: Material(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: child,
                  ),
                );
              },
              child: child,
            );
          },
          children: [
            for (int index = 0; index < selectedCategories.length; index++)
              _buildCategoryTile(context, state, selectedCategories, index),
          ],
        ),
        SizedBox(height: AppSpacing.xl.h),
      ],
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    QuestionSelectionLoaded state,
    List<QuestionCategoryEntity> selectedCategories,
    int index,
  ) {
    final category = selectedCategories[index];

    return Padding(
      key: ValueKey(category.id),
      padding: EdgeInsets.only(
        bottom: index == selectedCategories.length - 1 ? 0 : AppSpacing.md.h,
      ),
      child: DocumentCategorySummaryTile(
        category: category,
        questionsCount: state.selectedQuestionsCountForCategory(category.type),
        onEdit: () => _editCategory(context, category),
        onDelete: () => _confirmDeleteCategory(context, category),
      ),
    );
  }

  Future<void> _editCategory(
    BuildContext context,
    QuestionCategoryEntity category,
  ) async {
    await context.read<QuestionSelectionCubit>().selectCategory(category);
    if (context.mounted) context.pop();
  }

  Future<void> _confirmDeleteCategory(
    BuildContext context,
    QuestionCategoryEntity category,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(DocumentSummaryStrings.removeCategory),
          content: Text(
            '${DocumentSummaryStrings.removeCategoryConfirmation} '
            '${category.title}؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(DocumentSummaryStrings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(AppColors.coral),
              ),
              child: const Text(DocumentSummaryStrings.delete),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && context.mounted) {
      context.read<QuestionSelectionCubit>().clearCategory(category);
    }
  }
}
