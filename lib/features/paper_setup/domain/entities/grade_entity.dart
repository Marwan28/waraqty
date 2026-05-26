import 'package:waraqty/core/enums/grade_level.dart';

class GradeEntity {
  final GradeLevel level;
  final String title;
  final String subtitle;
  final int questionsCount;
  final int subjectsCount;

  const GradeEntity({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.questionsCount,
    required this.subjectsCount,
  });

  String get id => level.id;
  String get gradeLevel => level.arabicNumber;
}
