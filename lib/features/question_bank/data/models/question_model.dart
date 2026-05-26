import 'package:waraqty/core/enums/grade_level.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/core/enums/question_difficulty.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.id,
    required super.grade,
    required super.subjectId,
    required super.category,
    required super.questionText,
    super.options = const [],
    super.answerText,
    super.difficulty = QuestionDifficulty.medium,
    super.lessonName,
    super.unitName,
    super.source,
    super.createdAt,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] as String,
      grade: gradeLevelFromId(map['grade_id'] as String),
      subjectId: map['subject_id'] as String,
      category: questionCategoryTypeFromId(map['category_id'] as String),
      questionText: map['question_text'] as String,
      options: List<String>.from(map['options'] as List? ?? const []),
      answerText: map['answer_text'] as String?,
      difficulty: questionDifficultyFromId(
        map['difficulty_level'] as String? ?? QuestionDifficulty.medium.id,
      ),
      lessonName: map['lesson_name'] as String?,
      unitName: map['unit_name'] as String?,
      source: map['source'] as String?,
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'grade_id': grade.id,
      'subject_id': subjectId,
      'category_id': category.id,
      'question_text': questionText,
      'options': options,
      'answer_text': answerText,
      'difficulty_level': difficulty.id,
      'lesson_name': lessonName,
      'unit_name': unitName,
      'source': source,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  QuestionEntity toEntity() {
    return QuestionEntity(
      id: id,
      grade: grade,
      subjectId: subjectId,
      category: category,
      questionText: questionText,
      options: options,
      answerText: answerText,
      difficulty: difficulty,
      lessonName: lessonName,
      unitName: unitName,
      source: source,
      createdAt: createdAt,
    );
  }
}
