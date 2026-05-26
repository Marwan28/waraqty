import 'package:flutter_test/flutter_test.dart';
import 'package:waraqty/core/enums/grade_level.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/question_bank/data/datasources/local_datasource/question_bank_local_data_source.dart';
import 'package:waraqty/features/question_bank/data/datasources/local_datasource/questions.dart';

void main() {
  group('QuestionBankLocalDataSource', () {
    final dataSource = QuestionBankLocalDataSourceImpl();

    test('returns the expected categories for every grade', () async {
      for (final grade in GradeLevel.values) {
        final categories = await dataSource.getCategories(
          grade: grade,
          subjectId: SocialStudiesQuestions.subjectId,
        );

        expect(categories, hasLength(8));
        expect(
          categories.map((category) => category.type),
          orderedEquals(SocialStudiesQuestions.categories),
        );

        for (final category in categories) {
          expect(category.questionCount, 50);
        }
      }
    });

    test('returns 50 questions for every grade and category', () async {
      for (final grade in GradeLevel.values) {
        for (final category in QuestionCategoryType.values) {
          final questions = await dataSource.getQuestions(
            grade: grade,
            subjectId: SocialStudiesQuestions.subjectId,
            category: category,
          );

          expect(questions, hasLength(50));
          expect(
            questions.every((question) => question.grade == grade),
            isTrue,
          );
          expect(
            questions.every((question) => question.category == category),
            isTrue,
          );
          expect(
            questions.every(
              (question) =>
                  question.subjectId == SocialStudiesQuestions.subjectId,
            ),
            isTrue,
          );
        }
      }
    });

    test(
      'has unique question ids and texts across the full local bank',
      () async {
        final ids = <String>{};
        final texts = <String>{};
        var totalQuestions = 0;

        for (final grade in GradeLevel.values) {
          for (final category in QuestionCategoryType.values) {
            final questions = await dataSource.getQuestions(
              grade: grade,
              subjectId: SocialStudiesQuestions.subjectId,
              category: category,
            );

            totalQuestions += questions.length;

            for (final question in questions) {
              expect(ids.add(question.id), isTrue);
              expect(texts.add(question.questionText), isTrue);
            }
          }
        }

        expect(totalQuestions, 1200);
        expect(ids, hasLength(1200));
        expect(texts, hasLength(1200));
      },
    );

    test('returns empty lists for unsupported subjects', () async {
      final categories = await dataSource.getCategories(
        grade: GradeLevel.grade4,
        subjectId: 'arabic',
      );
      final questions = await dataSource.getQuestions(
        grade: GradeLevel.grade4,
        subjectId: 'arabic',
        category: QuestionCategoryType.multipleChoice,
      );

      expect(categories, isEmpty);
      expect(questions, isEmpty);
    });
  });
}
