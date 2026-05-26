import 'package:waraqty/core/enums/grade_level.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_entity.dart';
import 'package:waraqty/features/question_bank/domain/repositories/question_bank_repository.dart';

class GetQuestionsByFilterUseCase {
  final QuestionBankRepository repository;

  GetQuestionsByFilterUseCase({required this.repository});

  Future<List<QuestionEntity>> call({
    required GradeLevel grade,
    required String subjectId,
    required QuestionCategoryType category,
  }) {
    return repository.getQuestions(
      grade: grade,
      subjectId: subjectId,
      category: category,
    );
  }
}
