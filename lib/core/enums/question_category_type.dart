enum QuestionCategoryType {
  multipleChoice,
  complete,
  trueFalse,
  explain,
  define,
  essay,
  compare,
  whatHappens,
}

extension QuestionCategoryTypeExtension on QuestionCategoryType {
  String get id {
    switch (this) {
      case QuestionCategoryType.multipleChoice:
        return 'multiple_choice';
      case QuestionCategoryType.complete:
        return 'complete';
      case QuestionCategoryType.trueFalse:
        return 'true_false';
      case QuestionCategoryType.explain:
        return 'explain';
      case QuestionCategoryType.define:
        return 'define';
      case QuestionCategoryType.essay:
        return 'essay';
      case QuestionCategoryType.compare:
        return 'compare';
      case QuestionCategoryType.whatHappens:
        return 'what_happens';
    }
  }

  String get title {
    switch (this) {
      case QuestionCategoryType.multipleChoice:
        return 'اختر الإجابة الصحيحة';
      case QuestionCategoryType.complete:
        return 'أكمل العبارات';
      case QuestionCategoryType.trueFalse:
        return 'صح أم خطأ';
      case QuestionCategoryType.explain:
        return 'علل';
      case QuestionCategoryType.define:
        return 'عرف المصطلح';
      case QuestionCategoryType.essay:
        return 'أجب عما يأتي';
      case QuestionCategoryType.compare:
        return 'قارن بين';
      case QuestionCategoryType.whatHappens:
        return 'ما النتائج المترتبة على';
    }
  }

  String get description {
    switch (this) {
      case QuestionCategoryType.multipleChoice:
        return 'أسئلة اختيار من متعدد بإجابة واحدة صحيحة';
      case QuestionCategoryType.complete:
        return 'عبارات ناقصة يكتب الطالب تكملتها';
      case QuestionCategoryType.trueFalse:
        return 'عبارات يحدد الطالب صحتها أو خطأها';
      case QuestionCategoryType.explain:
        return 'أسئلة أسباب وتفسير';
      case QuestionCategoryType.define:
        return 'مصطلحات ومفاهيم مهمة';
      case QuestionCategoryType.essay:
        return 'أسئلة مقالية قصيرة أو متوسطة';
      case QuestionCategoryType.compare:
        return 'أسئلة مقارنة بين مفهومين أو أكثر';
      case QuestionCategoryType.whatHappens:
        return 'أسئلة نتائج مترتبة على حدث أو موقف';
    }
  }

  int get displayOrder {
    switch (this) {
      case QuestionCategoryType.multipleChoice:
        return 1;
      case QuestionCategoryType.complete:
        return 2;
      case QuestionCategoryType.trueFalse:
        return 3;
      case QuestionCategoryType.explain:
        return 4;
      case QuestionCategoryType.define:
        return 5;
      case QuestionCategoryType.essay:
        return 6;
      case QuestionCategoryType.compare:
        return 7;
      case QuestionCategoryType.whatHappens:
        return 8;
    }
  }

  int get defaultQuestionLimit {
    switch (this) {
      case QuestionCategoryType.multipleChoice:
      case QuestionCategoryType.complete:
      case QuestionCategoryType.trueFalse:
        return 10;
      case QuestionCategoryType.explain:
      case QuestionCategoryType.define:
      case QuestionCategoryType.essay:
        return 5;
      case QuestionCategoryType.compare:
      case QuestionCategoryType.whatHappens:
        return 4;
    }
  }

  int get defaultAnswerLines {
    switch (this) {
      case QuestionCategoryType.multipleChoice:
      case QuestionCategoryType.complete:
      case QuestionCategoryType.trueFalse:
        return 1;
      case QuestionCategoryType.define:
        return 2;
      case QuestionCategoryType.explain:
      case QuestionCategoryType.whatHappens:
        return 3;
      case QuestionCategoryType.essay:
      case QuestionCategoryType.compare:
        return 4;
    }
  }
}

QuestionCategoryType questionCategoryTypeFromId(String id) {
  switch (id) {
    case 'multiple_choice':
      return QuestionCategoryType.multipleChoice;
    case 'complete':
      return QuestionCategoryType.complete;
    case 'true_false':
      return QuestionCategoryType.trueFalse;
    case 'explain':
      return QuestionCategoryType.explain;
    case 'define':
      return QuestionCategoryType.define;
    case 'essay':
      return QuestionCategoryType.essay;
    case 'compare':
      return QuestionCategoryType.compare;
    case 'what_happens':
      return QuestionCategoryType.whatHappens;
    default:
      throw ArgumentError.value(id, 'id', 'Unsupported question category id');
  }
}
