import 'package:equatable/equatable.dart';
import 'package:waraqty/core/enums/question_category_type.dart';

class QuestionCategoryEntity extends Equatable {
  final QuestionCategoryType type;
  final String title;
  final String description;
  final int displayOrder;
  final int questionCount;
  final int defaultQuestionLimit;
  final int defaultAnswerLines;

  const QuestionCategoryEntity({
    required this.type,
    required this.title,
    required this.description,
    required this.displayOrder,
    required this.questionCount,
    required this.defaultQuestionLimit,
    required this.defaultAnswerLines,
  });

  String get id => type.id;

  @override
  List<Object?> get props => [
    type,
    title,
    description,
    displayOrder,
    questionCount,
    defaultQuestionLimit,
    defaultAnswerLines,
  ];
}
