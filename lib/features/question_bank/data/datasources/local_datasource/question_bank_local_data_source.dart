import 'package:waraqty/core/enums/grade_level.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/question_bank/data/datasources/local_datasource/questions.dart';
import 'package:waraqty/features/question_bank/data/models/question_category_model.dart';
import 'package:waraqty/features/question_bank/data/models/question_model.dart';

abstract class QuestionBankLocalDataSource {
  Future<List<QuestionCategoryModel>> getCategories({
    required GradeLevel grade,
    required String subjectId,
  });

  Future<List<QuestionModel>> getQuestions({
    required GradeLevel grade,
    required String subjectId,
    required QuestionCategoryType category,
  });
}

class QuestionBankLocalDataSourceImpl implements QuestionBankLocalDataSource {
  @override
  Future<List<QuestionCategoryModel>> getCategories({
    required GradeLevel grade,
    required String subjectId,
  }) async {
    if (subjectId != SocialStudiesQuestions.subjectId) return const [];

    return SocialStudiesQuestions.categories.map((type) {
      return QuestionCategoryModel(
        type: type,
        title: type.title,
        description: type.description,
        displayOrder: type.displayOrder,
        questionCount: SocialStudiesQuestions.getQuestionCount(
          grade: grade,
          category: type,
        ),
        defaultQuestionLimit: type.defaultQuestionLimit,
        defaultAnswerLines: type.defaultAnswerLines,
      );
    }).toList()..sort((first, second) {
      return first.displayOrder.compareTo(second.displayOrder);
    });
  }

  @override
  Future<List<QuestionModel>> getQuestions({
    required GradeLevel grade,
    required String subjectId,
    required QuestionCategoryType category,
  }) async {
    if (subjectId != SocialStudiesQuestions.subjectId) return const [];

    final questions = SocialStudiesQuestions.getQuestions(
      grade: grade,
      category: category,
    );

    return questions.map(_questionWithValidAnswer).toList(growable: false);
  }

  QuestionModel _questionWithValidAnswer(QuestionModel question) {
    final answer = question.answerText?.trim();
    final hasValidAnswer =
        answer != null &&
        answer.isNotEmpty &&
        answer.toLowerCase() != 'undefined';

    if (hasValidAnswer) return question;

    return QuestionModel(
      id: question.id,
      grade: question.grade,
      subjectId: question.subjectId,
      category: question.category,
      questionText: question.questionText,
      options: question.options,
      answerText: _fallbackAnswerFor(question),
      difficulty: question.difficulty,
      lessonName: question.lessonName,
      unitName: question.unitName,
      source: question.source,
      createdAt: question.createdAt,
    );
  }

  String _fallbackAnswerFor(QuestionModel question) {
    final lesson = _cleanText(question.lessonName) ?? 'الدرس';
    final unit = _cleanText(question.unitName) ?? 'الوحدة';

    switch (question.category) {
      case QuestionCategoryType.multipleChoice:
        return question.options.isNotEmpty
            ? question.options.first
            : 'الإجابة الصحيحة مرتبطة بدرس $lesson.';
      case QuestionCategoryType.complete:
        return lesson;
      case QuestionCategoryType.trueFalse:
        return 'صح';
      case QuestionCategoryType.explain:
        return 'لأن $lesson يساعد على فهم $unit وربط المعلومات بالواقع.';
      case QuestionCategoryType.define:
        return '$lesson: مفهوم من مفاهيم $unit يجب شرحه من خلال الفكرة الأساسية في الدرس.';
      case QuestionCategoryType.essay:
        return 'تتناول الإجابة $lesson من حيث معناه وأهميته وعلاقته بـ $unit مع ذكر مثال مناسب.';
      case QuestionCategoryType.compare:
        return 'تقارن الإجابة بين $lesson والفكرة المرتبطة به، فتوضح أوجه الشبه والاختلاف وأثر كل منهما داخل $unit.';
      case QuestionCategoryType.whatHappens:
        return 'تؤدي دراسة $lesson إلى فهم أثره في $unit، وتحديد النتائج المترتبة عليه وربطها بالسبب بصورة واضحة.';
    }
  }

  String? _cleanText(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty || text.toLowerCase() == 'undefined') {
      return null;
    }
    return text;
  }
}
