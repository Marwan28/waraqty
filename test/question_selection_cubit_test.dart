import 'package:flutter_test/flutter_test.dart';
import 'package:waraqty/core/enums/grade_level.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/paper_setup/domain/entities/grade_entity.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';
import 'package:waraqty/features/paper_setup/domain/entities/subject_entity.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_category_entity.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_entity.dart';
import 'package:waraqty/features/question_bank/domain/repositories/question_bank_repository.dart';
import 'package:waraqty/features/question_bank/domain/usecases/get_question_categories_use_case.dart';
import 'package:waraqty/features/question_bank/domain/usecases/get_questions_by_filter_use_case.dart';
import 'package:waraqty/features/question_bank/presentation/cubit/question_selection_cubit.dart';

void main() {
  test('can retry selecting a category after a loading error', () async {
    final repository = _FlakyQuestionBankRepository();
    final cubit = QuestionSelectionCubit(
      selectedGrade: const GradeEntity(
        level: GradeLevel.grade4,
        title: 'الصف الرابع',
        subtitle: '',
        questionsCount: 2,
        subjectsCount: 1,
      ),
      selectedSubject: const SubjectEntity(
        id: 'social_studies',
        title: 'الدراسات الاجتماعية',
        statusLabel: '',
        isAvailable: true,
        questionsCount: 2,
      ),
      selectedPaperType: const PaperTypeEntity(
        id: 'booklet',
        type: PaperType.booklet,
        title: 'ملزمة',
        subtitle: '',
      ),
      getQuestionCategoriesUseCase: GetQuestionCategoriesUseCase(
        repository: repository,
      ),
      getQuestionsByFilterUseCase: GetQuestionsByFilterUseCase(
        repository: repository,
      ),
    );

    await cubit.getCategories();
    expect(cubit.state, isA<QuestionSelectionLoaded>());

    await cubit.selectCategory(repository.categories.last);
    expect(cubit.state, isA<QuestionSelectionError>());

    repository.shouldFailComplete = false;
    await cubit.selectCategory(repository.categories.last);

    final recoveredState = cubit.state as QuestionSelectionLoaded;
    expect(recoveredState.selectedCategory.type, QuestionCategoryType.complete);
    expect(recoveredState.questions, hasLength(1));

    await cubit.close();
  });
}

class _FlakyQuestionBankRepository implements QuestionBankRepository {
  bool shouldFailComplete = true;

  final List<QuestionCategoryEntity> categories = const [
    QuestionCategoryEntity(
      type: QuestionCategoryType.multipleChoice,
      title: 'اختر',
      description: '',
      displayOrder: 0,
      questionCount: 1,
      defaultQuestionLimit: 1,
      defaultAnswerLines: 1,
    ),
    QuestionCategoryEntity(
      type: QuestionCategoryType.complete,
      title: 'أكمل',
      description: '',
      displayOrder: 1,
      questionCount: 1,
      defaultQuestionLimit: 1,
      defaultAnswerLines: 1,
    ),
  ];

  @override
  Future<List<QuestionCategoryEntity>> getCategories({
    required GradeLevel grade,
    required String subjectId,
  }) async {
    return categories;
  }

  @override
  Future<List<QuestionEntity>> getQuestions({
    required GradeLevel grade,
    required String subjectId,
    required QuestionCategoryType category,
  }) async {
    if (category == QuestionCategoryType.complete && shouldFailComplete) {
      throw StateError('Temporary loading failure');
    }

    return [
      QuestionEntity(
        id: category.id,
        grade: grade,
        subjectId: subjectId,
        category: category,
        questionText: 'سؤال ${category.id}',
        answerText: 'إجابة',
      ),
    ];
  }
}
