part of 'question_selection_cubit.dart';

@immutable
sealed class QuestionSelectionState {
  const QuestionSelectionState();
}

final class QuestionSelectionInitial extends QuestionSelectionState {
  const QuestionSelectionInitial();
}

class QuestionSelectionLoading extends QuestionSelectionState {
  final QuestionSelectionLoaded? previousState;

  const QuestionSelectionLoading({this.previousState});
}

class QuestionSelectionLoaded extends QuestionSelectionState {
  final List<QuestionCategoryEntity> categories;
  final QuestionCategoryEntity selectedCategory;
  final Map<QuestionCategoryType, List<QuestionEntity>> questionsByCategory;
  final Map<QuestionCategoryType, List<QuestionEntity>>
  selectedQuestionsByCategory;
  final Map<QuestionCategoryType, int?> categoryLimits;

  const QuestionSelectionLoaded({
    required this.categories,
    required this.selectedCategory,
    required this.questionsByCategory,
    required this.selectedQuestionsByCategory,
    required this.categoryLimits,
  });

  List<QuestionEntity> get questions {
    return questionsByCategory[selectedCategory.type] ?? const [];
  }

  List<QuestionEntity> get selectedQuestions {
    return selectedQuestionsByCategory[selectedCategory.type] ?? const [];
  }

  List<QuestionEntity> questionsForCategory(QuestionCategoryType categoryType) {
    return questionsByCategory[categoryType] ?? const [];
  }

  List<QuestionEntity> selectedQuestionsForCategory(
    QuestionCategoryType categoryType,
  ) {
    return selectedQuestionsByCategory[categoryType] ?? const [];
  }

  List<QuestionEntity> get allSelectedQuestions {
    return selectedQuestionsByCategory.values
        .expand((questions) => questions)
        .toList(growable: false);
  }

  bool get canContinue => allSelectedQuestions.isNotEmpty;

  int get selectedQuestionsCount => allSelectedQuestions.length;

  int selectedQuestionsCountForCategory(QuestionCategoryType categoryType) {
    return selectedQuestionsForCategory(categoryType).length;
  }

  int? get currentCategoryLimit => categoryLimits[selectedCategory.type];

  int? categoryLimitFor(QuestionCategoryType categoryType) {
    return categoryLimits[categoryType];
  }

  int get currentCategoryTarget {
    return selectionTargetForCategory(selectedCategory.type);
  }

  int selectionTargetForCategory(QuestionCategoryType categoryType) {
    final category = categories.firstWhere(
      (category) => category.type == categoryType,
    );
    final availableQuestionsCount =
        questionsByCategory[categoryType]?.length ?? category.questionCount;
    final limit = categoryLimits[categoryType];

    if (availableQuestionsCount <= 0) return 0;
    if (limit == null) return availableQuestionsCount;
    if (limit < 1) return 1;
    if (limit > availableQuestionsCount) return availableQuestionsCount;

    return limit;
  }

  int get totalSelectionTarget {
    return categories.fold(0, (total, category) {
      return total + selectionTargetForCategory(category.type);
    });
  }

  bool get isCurrentCategoryUnlimited => currentCategoryLimit == null;

  bool isCategoryUnlimited(QuestionCategoryType categoryType) {
    return categoryLimitFor(categoryType) == null;
  }

  bool get hasReachedCurrentCategoryLimit {
    if (isCurrentCategoryUnlimited) return false;
    return selectedQuestions.length >= currentCategoryLimit!;
  }

  bool isQuestionSelected(QuestionEntity question) {
    return selectedQuestions.any(
      (selectedQuestion) => selectedQuestion.id == question.id,
    );
  }

  QuestionSelectionLoaded copyWith({
    List<QuestionCategoryEntity>? categories,
    QuestionCategoryEntity? selectedCategory,
    Map<QuestionCategoryType, List<QuestionEntity>>? questionsByCategory,
    Map<QuestionCategoryType, List<QuestionEntity>>?
    selectedQuestionsByCategory,
    Map<QuestionCategoryType, int?>? categoryLimits,
  }) {
    return QuestionSelectionLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      questionsByCategory: questionsByCategory ?? this.questionsByCategory,
      selectedQuestionsByCategory:
          selectedQuestionsByCategory ?? this.selectedQuestionsByCategory,
      categoryLimits: categoryLimits ?? this.categoryLimits,
    );
  }
}

class QuestionSelectionError extends QuestionSelectionState {
  final String message;
  final QuestionSelectionLoaded? previousState;

  const QuestionSelectionError({required this.message, this.previousState});
}
