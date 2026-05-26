import 'package:waraqty/core/enums/grade_level.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/question_bank/data/datasources/local_datasource/question_bank_local_data_source.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_category_entity.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_entity.dart';
import 'package:waraqty/features/question_bank/domain/repositories/question_bank_repository.dart';

class QuestionBankRepositoryImpl implements QuestionBankRepository {
  final QuestionBankLocalDataSource localDataSource;

  const QuestionBankRepositoryImpl({required this.localDataSource});

  @override
  Future<List<QuestionCategoryEntity>> getCategories({
    required GradeLevel grade,
    required String subjectId,
  }) async {
    final categories = await localDataSource.getCategories(
      grade: grade,
      subjectId: subjectId,
    );

    return categories.map((category) => category.toEntity()).toList();
  }

  @override
  Future<List<QuestionEntity>> getQuestions({
    required GradeLevel grade,
    required String subjectId,
    required QuestionCategoryType category,
  }) async {
    final questions = await localDataSource.getQuestions(
      grade: grade,
      subjectId: subjectId,
      category: category,
    );

    return questions.map((question) => question.toEntity()).toList();
  }
}
