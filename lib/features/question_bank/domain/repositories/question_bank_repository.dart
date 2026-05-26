import 'package:waraqty/core/enums/grade_level.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_category_entity.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_entity.dart';

abstract class QuestionBankRepository {
  Future<List<QuestionCategoryEntity>> getCategories({
    required GradeLevel grade,
    required String subjectId,
  });

  Future<List<QuestionEntity>> getQuestions({
    required GradeLevel grade,
    required String subjectId,
    required QuestionCategoryType category,
  });
}
