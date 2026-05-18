class GradeEntity {
  final String id;
  final String title;
  final String subtitle;
  final String gradeLevel;
  final int questionsCount;
  final int subjectsCount;

  const GradeEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.gradeLevel,
    required this.questionsCount,
    required this.subjectsCount,
  });
}
