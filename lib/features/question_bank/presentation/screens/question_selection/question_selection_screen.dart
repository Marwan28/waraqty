import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:waraqty/core/constants/app_routes.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_setup_back_button.dart';
import 'package:waraqty/features/question_bank/presentation/cubit/question_selection_cubit.dart';
import 'package:waraqty/features/question_bank/presentation/widgets/question_selection/question_card.dart';
import 'package:waraqty/features/question_bank/presentation/widgets/question_selection/question_category_card.dart';
import 'package:waraqty/features/question_bank/presentation/widgets/question_selection/question_selection_bottom_bar.dart';
import 'package:waraqty/features/question_bank/presentation/widgets/question_selection/question_selection_empty_view.dart';
import 'package:waraqty/features/question_bank/presentation/widgets/question_selection/question_selection_error_view.dart';
import 'package:waraqty/features/question_bank/presentation/widgets/question_selection/question_selection_limit_card.dart';

class QuestionSelectionScreen extends StatefulWidget {
  const QuestionSelectionScreen({super.key});

  @override
  State<QuestionSelectionScreen> createState() =>
      _QuestionSelectionScreenState();
}

class _QuestionSelectionScreenState extends State<QuestionSelectionScreen> {
  bool _hasLoadedData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasLoadedData) return;
    _hasLoadedData = true;
    context.read<QuestionSelectionCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      body: SafeArea(
        child: BlocBuilder<QuestionSelectionCubit, QuestionSelectionState>(
          builder: (context, state) {
            final loadedState = _loadedStateFrom(state);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(
                  context,
                  selectedQuestionsCount:
                      loadedState?.selectedQuestionsCount ?? 0,
                  selectionTarget: loadedState?.totalSelectionTarget ?? 0,
                ),
                Divider(
                  height: 1.h,
                  thickness: 1.h,
                  color: const Color(AppColors.border),
                ),
                if (loadedState == null)
                  Expanded(child: _buildInitialState(context, state))
                else
                  Expanded(
                    child: _buildLoadedState(context, state, loadedState),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required int selectedQuestionsCount,
    required int selectionTarget,
  }) {
    final cubit = context.read<QuestionSelectionCubit>();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontalPadding.w,
        AppSpacing.xl.h,
        AppSpacing.screenHorizontalPadding.w,
        AppSpacing.lg.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PaperSetupBackButton(onPressed: () => context.pop()),
          SizedBox(width: AppSpacing.lg.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  QuestionSelectionStrings.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleLarge.copyWith(fontSize: 28.sp),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  '${cubit.selectedPaperType.title} • ${cubit.selectedGrade.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(AppColors.textSecondary),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.lg.w),
          _buildSelectedCountRing(
            selectedQuestionsCount: selectedQuestionsCount,
            selectionTarget: selectionTarget,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedCountRing({
    required int selectedQuestionsCount,
    required int selectionTarget,
  }) {
    final progress = selectionTarget <= 0
        ? 0.08
        : (selectedQuestionsCount / selectionTarget).clamp(0.08, 1.0);

    return SizedBox(
      width: 58.w,
      height: 58.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 58.w,
            height: 58.w,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4.w,
              color: const Color(AppColors.primary),
              backgroundColor: const Color(AppColors.border),
            ),
          ),
          Text(
            '$selectedQuestionsCount\n${QuestionSelectionStrings.questions}',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: const Color(AppColors.textPrimary),
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  QuestionSelectionLoaded? _loadedStateFrom(QuestionSelectionState state) {
    if (state is QuestionSelectionLoaded) return state;
    if (state is QuestionSelectionLoading) return state.previousState;
    if (state is QuestionSelectionError) return state.previousState;
    return null;
  }

  Widget _buildInitialState(
    BuildContext context,
    QuestionSelectionState state,
  ) {
    if (state is QuestionSelectionError) {
      return QuestionSelectionErrorView(
        message: state.message,
        onRetry: () => context.read<QuestionSelectionCubit>().getCategories(),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLoadedState(
    BuildContext context,
    QuestionSelectionState state,
    QuestionSelectionLoaded loadedState,
  ) {
    final isLoading = state is QuestionSelectionLoading;
    final errorMessage = state is QuestionSelectionError ? state.message : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isLoading)
          LinearProgressIndicator(
            minHeight: 2.h,
            color: const Color(AppColors.primary),
            backgroundColor: const Color(AppColors.primarySoft),
          ),
        if (errorMessage != null) _buildInlineError(errorMessage),
        Container(
          height: 74.h,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
          decoration: BoxDecoration(
            color: const Color(AppColors.surface),
            border: Border(
              bottom: BorderSide(
                color: const Color(AppColors.borderSoft),
                width: 1.w,
              ),
            ),
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontalPadding.w,
            ),
            itemCount: loadedState.categories.length,
            itemBuilder: (context, index) {
              final category = loadedState.categories[index];
              return QuestionCategoryCard(
                category: category,
                isSelected: category.type == loadedState.selectedCategory.type,
                selectedQuestionsCount: loadedState
                    .selectedQuestionsCountForCategory(category.type),
                onTap: () => context
                    .read<QuestionSelectionCubit>()
                    .selectCategory(category),
              );
            },
            separatorBuilder: (context, index) =>
                SizedBox(width: AppSpacing.md.w),
          ),
        ),
        Expanded(child: _buildScrollableContent(context, loadedState)),
        QuestionSelectionBottomBar(
          selectedQuestionsCount: loadedState.selectedQuestionsCount,
          canContinue: loadedState.canContinue,
          onClearAll: context
              .read<QuestionSelectionCubit>()
              .clearAllSelectedQuestions,
          onContinue: () => context.push(AppRoutes.documentSummary),
        ),
      ],
    );
  }

  Widget _buildScrollableContent(
    BuildContext context,
    QuestionSelectionLoaded state,
  ) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0, AppSpacing.md.h, 0, AppSpacing.xl.h),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontalPadding.w,
          ),
          child: QuestionSelectionLimitCard(
            selectedCategory: state.selectedCategory,
            selectedQuestionsCount: state.selectedQuestions.length,
            questionsCount: state.questions.length,
            limit: state.currentCategoryLimit,
            onDecreaseLimit: _decreaseLimit,
            onIncreaseLimit: _canIncreaseLimit(state) ? _increaseLimit : null,
            onSetDefaultLimit: _setDefaultLimit,
            onSetUnlimited: context
                .read<QuestionSelectionCubit>()
                .setCurrentCategoryUnlimited,
            onSelectAll: context
                .read<QuestionSelectionCubit>()
                .selectAllCurrentCategory,
            onClearCategory: context
                .read<QuestionSelectionCubit>()
                .clearCurrentCategory,
          ),
        ),
        SizedBox(height: AppSpacing.xl.h),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontalPadding.w,
          ),
          child: _buildQuestionBankHeader(state),
        ),
        SizedBox(height: AppSpacing.md.h),
        _buildQuestionsSection(context, state),
      ],
    );
  }

  Widget _buildQuestionBankHeader(QuestionSelectionLoaded state) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${QuestionSelectionStrings.questionBankTitle} ${state.selectedCategory.title}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                '${state.questions.length} ${QuestionSelectionStrings.questionBankMeta}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsSection(
    BuildContext context,
    QuestionSelectionLoaded state,
  ) {
    if (state.questions.isEmpty) {
      return SizedBox(height: 280.h, child: const QuestionSelectionEmptyView());
    }

    return Column(
      children: List.generate(state.questions.length, (index) {
        final question = state.questions[index];
        final isSelected = state.isQuestionSelected(question);
        final canSelect = isSelected || !state.hasReachedCurrentCategoryLimit;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontalPadding.w,
            0,
            AppSpacing.screenHorizontalPadding.w,
            index == state.questions.length - 1 ? 0 : AppSpacing.md.h,
          ),
          child: QuestionCard(
            questionNumber: index + 1,
            question: question,
            isSelected: isSelected,
            canSelect: canSelect,
            onTap: () =>
                context.read<QuestionSelectionCubit>().toggleQuestion(question),
          ),
        );
      }),
    );
  }

  Widget _buildInlineError(String message) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontalPadding.w,
        AppSpacing.md.h,
        AppSpacing.screenHorizontalPadding.w,
        0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: const Color(AppColors.coralSoft),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(AppColors.coral)),
      ),
      child: Text(
        message,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: const Color(AppColors.coral),
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _decreaseLimit() {
    final cubit = context.read<QuestionSelectionCubit>();
    final state = cubit.state;
    if (state is! QuestionSelectionLoaded) return;

    final currentLimit = state.currentCategoryLimit;
    if (currentLimit == null || currentLimit <= 1) return;

    cubit.setCategoryLimit(
      category: state.selectedCategory,
      limit: currentLimit - 1,
    );
  }

  void _increaseLimit() {
    final cubit = context.read<QuestionSelectionCubit>();
    final state = cubit.state;
    if (state is! QuestionSelectionLoaded) return;

    final currentLimit = state.currentCategoryLimit;
    final nextLimit = currentLimit == null
        ? state.selectedCategory.defaultQuestionLimit
        : currentLimit + 1;
    final questionsCount = state.questions.length;
    if (questionsCount <= 0) return;
    final safeNextLimit = nextLimit > questionsCount
        ? questionsCount
        : nextLimit;

    cubit.setCategoryLimit(
      category: state.selectedCategory,
      limit: safeNextLimit,
    );
  }

  void _setDefaultLimit() {
    final cubit = context.read<QuestionSelectionCubit>();
    final state = cubit.state;
    if (state is! QuestionSelectionLoaded) return;

    final questionsCount = state.questions.length;
    if (questionsCount <= 0) return;

    final defaultLimit = state.selectedCategory.defaultQuestionLimit;
    final safeDefaultLimit = defaultLimit > questionsCount
        ? questionsCount
        : defaultLimit;

    cubit.setCategoryLimit(
      category: state.selectedCategory,
      limit: safeDefaultLimit,
    );
  }

  bool _canIncreaseLimit(QuestionSelectionLoaded state) {
    if (state.questions.isEmpty) return false;

    final currentLimit = state.currentCategoryLimit;
    if (currentLimit == null) return true;

    return currentLimit < state.questions.length;
  }
}
