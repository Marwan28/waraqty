import 'package:equatable/equatable.dart';
import 'package:waraqty/core/enums/grade_level.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/core/enums/question_difficulty.dart';

class QuestionEntity extends Equatable {
  final String id;
  final GradeLevel grade;
  final String subjectId;
  final QuestionCategoryType category;
  final String questionText;
  final List<String> options;
  final String? answerText;
  final QuestionDifficulty difficulty;
  final String? lessonName;
  final String? unitName;
  final String? source;
  final DateTime? createdAt;

  const QuestionEntity({
    required this.id,
    required this.grade,
    required this.subjectId,
    required this.category,
    required this.questionText,
    this.options = const [],
    this.answerText,
    this.difficulty = QuestionDifficulty.medium,
    this.lessonName,
    this.unitName,
    this.source,
    this.createdAt,
  });

  String get gradeId => grade.id;
  String get categoryId => category.id;
  String get difficultyLevel => difficulty.id;
  bool get hasOptions => options.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    grade,
    subjectId,
    category,
    questionText,
    options,
    answerText,
    difficulty,
    lessonName,
    unitName,
    source,
    createdAt,
  ];
}
