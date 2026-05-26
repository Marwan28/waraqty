enum GradeLevel { grade4, grade5, grade6 }

extension GradeLevelExtension on GradeLevel {
  String get id {
    switch (this) {
      case GradeLevel.grade4:
        return 'grade_4';
      case GradeLevel.grade5:
        return 'grade_5';
      case GradeLevel.grade6:
        return 'grade_6';
    }
  }

  String get arabicNumber {
    switch (this) {
      case GradeLevel.grade4:
        return '٤';
      case GradeLevel.grade5:
        return '٥';
      case GradeLevel.grade6:
        return '٦';
    }
  }
}

GradeLevel gradeLevelFromId(String id) {
  switch (id) {
    case 'grade_4':
      return GradeLevel.grade4;
    case 'grade_5':
      return GradeLevel.grade5;
    case 'grade_6':
      return GradeLevel.grade6;
    default:
      throw ArgumentError.value(id, 'id', 'Unsupported grade id');
  }
}
