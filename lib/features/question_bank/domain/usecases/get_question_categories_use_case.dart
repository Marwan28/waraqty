import 'package:waraqty/core/enums/grade_level.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_category_entity.dart';
import 'package:waraqty/features/question_bank/domain/repositories/question_bank_repository.dart';

class GetQuestionCategoriesUseCase {
  final QuestionBankRepository repository;

  GetQuestionCategoriesUseCase({required this.repository});

  Future<List<QuestionCategoryEntity>> call({
    required GradeLevel grade,
    required String subjectId,
  }) {
    return repository.getCategories(grade: grade, subjectId: subjectId);
  }
}
