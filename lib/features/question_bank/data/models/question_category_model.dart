import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_category_entity.dart';

class QuestionCategoryModel extends QuestionCategoryEntity {
  const QuestionCategoryModel({
    required super.type,
    required super.title,
    required super.description,
    required super.displayOrder,
    required super.questionCount,
    required super.defaultQuestionLimit,
    required super.defaultAnswerLines,
  });

  factory QuestionCategoryModel.fromMap(Map<String, dynamic> map) {
    final type = questionCategoryTypeFromId(map['id'] as String);

    return QuestionCategoryModel(
      type: type,
      title: map['title'] as String? ?? type.title,
      description: map['description'] as String? ?? type.description,
      displayOrder: map['display_order'] as int? ?? type.displayOrder,
      questionCount: map['question_count'] as int? ?? 0,
      defaultQuestionLimit:
          map['default_question_limit'] as int? ?? type.defaultQuestionLimit,
      defaultAnswerLines:
          map['default_answer_lines'] as int? ?? type.defaultAnswerLines,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'display_order': displayOrder,
      'question_count': questionCount,
      'default_question_limit': defaultQuestionLimit,
      'default_answer_lines': defaultAnswerLines,
    };
  }

  QuestionCategoryEntity toEntity() {
    return QuestionCategoryEntity(
      type: type,
      title: title,
      description: description,
      displayOrder: displayOrder,
      questionCount: questionCount,
      defaultQuestionLimit: defaultQuestionLimit,
      defaultAnswerLines: defaultAnswerLines,
    );
  }
}
