import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/paper_setup/domain/entities/grade_entity.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';
import 'package:waraqty/features/paper_setup/domain/entities/subject_entity.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_category_entity.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_entity.dart';
import 'package:waraqty/features/question_bank/domain/usecases/get_question_categories_use_case.dart';
import 'package:waraqty/features/question_bank/domain/usecases/get_questions_by_filter_use_case.dart';

part 'question_selection_state.dart';

class QuestionSelectionCubit extends Cubit<QuestionSelectionState> {
  QuestionSelectionCubit({
    required this.selectedSubject,
    required this.selectedGrade,
    required this.selectedPaperType,
    required this.getQuestionCategoriesUseCase,
    required this.getQuestionsByFilterUseCase,
  }) : super(const QuestionSelectionInitial());
  final GradeEntity selectedGrade;
  final SubjectEntity selectedSubject;
  final PaperTypeEntity selectedPaperType;
  final GetQuestionCategoriesUseCase getQuestionCategoriesUseCase;
  final GetQuestionsByFilterUseCase getQuestionsByFilterUseCase;

  Future<void> getCategories() async {
    emit(const QuestionSelectionLoading());
    try {
      final categories = await getQuestionCategoriesUseCase.call(
        grade: selectedGrade.level,
        subjectId: selectedSubject.id,
      );

      if (categories.isEmpty) {
        emit(
          const QuestionSelectionError(
            message: 'لا توجد تصنيفات أسئلة متاحة لهذه المادة.',
          ),
        );
        return;
      }

      final selectedCategory = categories.first;
      final questions = await _loadQuestionsByCategory(selectedCategory);

      emit(
        QuestionSelectionLoaded(
          categories: categories,
          selectedCategory: selectedCategory,
          questionsByCategory: {selectedCategory.type: questions},
          selectedQuestionsByCategory: const {},
          categoryLimits: _buildDefaultCategoryLimits(categories),
        ),
      );
    } catch (e) {
      emit(QuestionSelectionError(message: e.toString()));
    }
  }

  Future<void> getQuestionsByCategory(QuestionCategoryEntity category) async {
    await selectCategory(category);
  }

  Future<void> selectCategory(QuestionCategoryEntity category) async {
    final currentState = state;
    if (currentState is! QuestionSelectionLoaded) return;

    if (currentState.questionsByCategory.containsKey(category.type)) {
      emit(currentState.copyWith(selectedCategory: category));
      return;
    }

    emit(QuestionSelectionLoading(previousState: currentState));

    try {
      final questions = await _loadQuestionsByCategory(category);
      final updatedQuestionsByCategory =
          Map<QuestionCategoryType, List<QuestionEntity>>.from(
            currentState.questionsByCategory,
          )..[category.type] = questions;

      emit(
        currentState.copyWith(
          selectedCategory: category,
          questionsByCategory: Map.unmodifiable(updatedQuestionsByCategory),
        ),
      );
    } catch (e) {
      emit(
        QuestionSelectionError(
          message: e.toString(),
          previousState: currentState,
        ),
      );
    }
  }

  void toggleQuestion(QuestionEntity question) {
    final currentState = state;
    if (currentState is! QuestionSelectionLoaded) return;

    final selectedQuestions = [
      ...(currentState.selectedQuestionsByCategory[question.category] ??
          const <QuestionEntity>[]),
    ];
    final selectedIndex = selectedQuestions.indexWhere(
      (selectedQuestion) => selectedQuestion.id == question.id,
    );

    if (selectedIndex >= 0) {
      selectedQuestions.removeAt(selectedIndex);
    } else {
      final limit = currentState.categoryLimits[question.category];
      if (limit != null && selectedQuestions.length >= limit) return;
      selectedQuestions.add(question);
    }

    _emitSelectedQuestionsForCategory(question.category, selectedQuestions);
  }

  void selectAllCurrentCategory() {
    final currentState = state;
    if (currentState is! QuestionSelectionLoaded) return;

    final categoryType = currentState.selectedCategory.type;
    final selectedQuestions = [
      ...(currentState.selectedQuestionsByCategory[categoryType] ??
          const <QuestionEntity>[]),
    ];
    final limit = currentState.categoryLimits[categoryType];

    for (final question in currentState.questions) {
      final isAlreadySelected = selectedQuestions.any(
        (selectedQuestion) => selectedQuestion.id == question.id,
      );
      if (isAlreadySelected) continue;
      if (limit != null && selectedQuestions.length >= limit) break;

      selectedQuestions.add(question);
    }

    _emitSelectedQuestionsForCategory(categoryType, selectedQuestions);
  }

  void clearCurrentCategory() {
    final currentState = state;
    if (currentState is! QuestionSelectionLoaded) return;

    final updatedSelectedQuestions =
        Map<QuestionCategoryType, List<QuestionEntity>>.from(
          currentState.selectedQuestionsByCategory,
        )..remove(currentState.selectedCategory.type);

    emit(
      currentState.copyWith(
        selectedQuestionsByCategory: Map.unmodifiable(updatedSelectedQuestions),
      ),
    );
  }

  void clearAllSelectedQuestions() {
    final currentState = state;
    if (currentState is! QuestionSelectionLoaded) return;

    emit(currentState.copyWith(selectedQuestionsByCategory: const {}));
  }

  void setCategoryLimit({
    required QuestionCategoryEntity category,
    required int limit,
  }) {
    final currentState = state;
    if (currentState is! QuestionSelectionLoaded) return;

    final safeLimit = limit < 1 ? 1 : limit;
    final updatedLimits = Map<QuestionCategoryType, int?>.from(
      currentState.categoryLimits,
    )..[category.type] = safeLimit;

    final selectedQuestions = [
      ...(currentState.selectedQuestionsByCategory[category.type] ??
          const <QuestionEntity>[]),
    ];
    final trimmedSelectedQuestions = selectedQuestions.take(safeLimit).toList();
    final updatedSelectedQuestions =
        Map<QuestionCategoryType, List<QuestionEntity>>.from(
          currentState.selectedQuestionsByCategory,
        );

    if (trimmedSelectedQuestions.isEmpty) {
      updatedSelectedQuestions.remove(category.type);
    } else {
      updatedSelectedQuestions[category.type] = List.unmodifiable(
        trimmedSelectedQuestions,
      );
    }

    emit(
      currentState.copyWith(
        categoryLimits: Map.unmodifiable(updatedLimits),
        selectedQuestionsByCategory: Map.unmodifiable(updatedSelectedQuestions),
      ),
    );
  }

  void setCurrentCategoryUnlimited() {
    final currentState = state;
    if (currentState is! QuestionSelectionLoaded) return;

    final updatedLimits = Map<QuestionCategoryType, int?>.from(
      currentState.categoryLimits,
    )..[currentState.selectedCategory.type] = null;

    emit(
      currentState.copyWith(categoryLimits: Map.unmodifiable(updatedLimits)),
    );
  }

  Future<List<QuestionEntity>> _loadQuestionsByCategory(
    QuestionCategoryEntity category,
  ) {
    return getQuestionsByFilterUseCase.call(
      grade: selectedGrade.level,
      subjectId: selectedSubject.id,
      category: category.type,
    );
  }

  Map<QuestionCategoryType, int?> _buildDefaultCategoryLimits(
    List<QuestionCategoryEntity> categories,
  ) {
    return Map.unmodifiable({
      for (final category in categories)
        category.type: category.defaultQuestionLimit,
    });
  }

  void _emitSelectedQuestionsForCategory(
    QuestionCategoryType categoryType,
    List<QuestionEntity> selectedQuestions,
  ) {
    final currentState = state;
    if (currentState is! QuestionSelectionLoaded) return;

    final updatedSelectedQuestions =
        Map<QuestionCategoryType, List<QuestionEntity>>.from(
          currentState.selectedQuestionsByCategory,
        );

    if (selectedQuestions.isEmpty) {
      updatedSelectedQuestions.remove(categoryType);
    } else {
      updatedSelectedQuestions[categoryType] = List.unmodifiable(
        selectedQuestions,
      );
    }

    emit(
      currentState.copyWith(
        selectedQuestionsByCategory: Map.unmodifiable(updatedSelectedQuestions),
      ),
    );
  }
}
