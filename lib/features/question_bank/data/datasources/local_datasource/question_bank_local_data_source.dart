import 'package:waraqty/core/enums/grade_level.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/question_bank/data/datasources/local_datasource/questions.dart';
import 'package:waraqty/features/question_bank/data/models/question_category_model.dart';
import 'package:waraqty/features/question_bank/data/models/question_model.dart';

abstract class QuestionBankLocalDataSource {
  Future<List<QuestionCategoryModel>> getCategories({
    required GradeLevel grade,
    required String subjectId,
  });

  Future<List<QuestionModel>> getQuestions({
    required GradeLevel grade,
    required String subjectId,
    required QuestionCategoryType category,
  });
}

class QuestionBankLocalDataSourceImpl implements QuestionBankLocalDataSource {
  @override
  Future<List<QuestionCategoryModel>> getCategories({
    required GradeLevel grade,
    required String subjectId,
  }) async {
    if (subjectId != SocialStudiesQuestions.subjectId) return const [];

    return SocialStudiesQuestions.categories.map((type) {
      return QuestionCategoryModel(
        type: type,
        title: type.title,
        description: type.description,
        displayOrder: type.displayOrder,
        questionCount: SocialStudiesQuestions.getQuestionCount(
          grade: grade,
          category: type,
        ),
        defaultQuestionLimit: type.defaultQuestionLimit,
        defaultAnswerLines: type.defaultAnswerLines,
      );
    }).toList()..sort((first, second) {
      return first.displayOrder.compareTo(second.displayOrder);
    });
  }

  @override
  Future<List<QuestionModel>> getQuestions({
    required GradeLevel grade,
    required String subjectId,
    required QuestionCategoryType category,
  }) async {
    if (subjectId != SocialStudiesQuestions.subjectId) return const [];

    return SocialStudiesQuestions.getQuestions(
      grade: grade,
      category: category,
    );
  }
}
