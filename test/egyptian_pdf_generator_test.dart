import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:waraqty/core/enums/grade_level.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/document_builder/data/services/egyptian_pdf_generator.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_data_entity.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_section_entity.dart';
import 'package:waraqty/features/document_builder/domain/entities/generated_pdf_file_entity.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final generator = EgyptianPdfGenerator();

  test('generates one valid PDF for a booklet', () async {
    final files = await generator.generate(_documentData(PaperType.booklet));

    expect(files, hasLength(1));
    expect(files.single.kind, GeneratedPdfFileKind.booklet);
    expect(_hasPdfSignature(files.single.bytes), isTrue);
  });

  test('generates an exam and a valid answer key PDF', () async {
    final files = await generator.generate(_documentData(PaperType.exam));

    expect(files, hasLength(2));
    expect(files[0].kind, GeneratedPdfFileKind.exam);
    expect(files[1].kind, GeneratedPdfFileKind.answerKey);
    expect(_hasPdfSignature(files[0].bytes), isTrue);
    expect(_hasPdfSignature(files[1].bytes), isTrue);
  });
}

DocumentDataEntity _documentData(PaperType paperType) {
  return DocumentDataEntity(
    gradeTitle: 'الصف السادس الابتدائي',
    subjectTitle: 'الدراسات الاجتماعية',
    paperType: paperType,
    sections: [
      DocumentSectionEntity(
        category: QuestionCategoryType.multipleChoice,
        questions: const [
          QuestionEntity(
            id: 'q1',
            grade: GradeLevel.grade6,
            subjectId: 'social_studies',
            category: QuestionCategoryType.multipleChoice,
            questionText: 'تقع جمهورية مصر العربية في قارة ........',
            options: ['آسيا', 'أفريقيا', 'أوروبا', 'أمريكا الجنوبية'],
            answerText: 'أفريقيا',
          ),
        ],
      ),
      DocumentSectionEntity(
        category: QuestionCategoryType.explain,
        questions: const [
          QuestionEntity(
            id: 'q2',
            grade: GradeLevel.grade6,
            subjectId: 'social_studies',
            category: QuestionCategoryType.explain,
            questionText: 'أهمية نهر النيل لمصر.',
            answerText: 'مصدر للمياه ويساعد على الزراعة وتوليد الكهرباء.',
          ),
        ],
      ),
    ],
    bookletTitle: 'مراجعة شاملة',
    teacherName: 'أ. مروان',
    teacherPhoneNumber: '01000000000',
    bookletTemplate: 'بسيط',
    includeBookletAnswers: true,
    schoolName: 'مدرسة النور الابتدائية',
    governorate: 'القاهرة',
    educationalAdministration: 'إدارة شرق التعليمية',
    examTitle: 'امتحان الفصل الدراسي الأول',
    academicYear: '2025 / 2026',
    termName: 'الفصل الدراسي الأول',
    examDuration: 'ساعة ونصف',
    totalGrade: '40',
    includeAnswerSpaces: true,
    fontSize: 14,
  );
}

bool _hasPdfSignature(List<int> bytes) {
  if (bytes.length < 4) return false;
  return ascii.decode(bytes.take(4).toList()) == '%PDF';
}
