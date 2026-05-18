class SubjectEntity {
  final String id;
  final String title;
  final String statusLabel;
  final bool isAvailable;
  final int questionsCount;
  final String? questionsCountPrefix;
  final String? questionsCountSuffix;

  const SubjectEntity({
    required this.id,
    required this.title,
    required this.statusLabel,
    required this.isAvailable,
    required this.questionsCount,
    this.questionsCountPrefix,
    this.questionsCountSuffix,
  });

  bool get hasQuestionsCountText =>
      questionsCountPrefix != null && questionsCountSuffix != null;
}
