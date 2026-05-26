enum QuestionDifficulty { easy, medium, hard }

extension QuestionDifficultyExtension on QuestionDifficulty {
  String get id {
    switch (this) {
      case QuestionDifficulty.easy:
        return 'easy';
      case QuestionDifficulty.medium:
        return 'medium';
      case QuestionDifficulty.hard:
        return 'hard';
    }
  }

  String get title {
    switch (this) {
      case QuestionDifficulty.easy:
        return 'سهل';
      case QuestionDifficulty.medium:
        return 'متوسط';
      case QuestionDifficulty.hard:
        return 'صعب';
    }
  }
}

QuestionDifficulty questionDifficultyFromId(String id) {
  switch (id) {
    case 'easy':
      return QuestionDifficulty.easy;
    case 'medium':
      return QuestionDifficulty.medium;
    case 'hard':
      return QuestionDifficulty.hard;
    default:
      throw ArgumentError.value(id, 'id', 'Unsupported question difficulty id');
  }
}
