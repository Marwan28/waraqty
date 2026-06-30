import 'package:equatable/equatable.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_section_entity.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_template.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';

class DocumentDataEntity extends Equatable {
  final String gradeTitle;
  final String subjectTitle;
  final PaperType paperType;
  final List<DocumentSectionEntity> sections;

  final String bookletTitle;
  final String teacherName;
  final String teacherPhoneNumber;
  final BookletTemplate bookletTemplate;
  final bool includeBookletAnswers;

  final String schoolName;
  final String governorate;
  final String educationalAdministration;
  final String examTitle;
  final String academicYear;
  final String termName;
  final String examDuration;
  final String totalGrade;
  final ExamTemplate examTemplate;
  final bool includeAnswerSpaces;

  final double fontSize;

  const DocumentDataEntity({
    required this.gradeTitle,
    required this.subjectTitle,
    required this.paperType,
    required this.sections,
    required this.bookletTitle,
    required this.teacherName,
    required this.teacherPhoneNumber,
    required this.bookletTemplate,
    required this.includeBookletAnswers,
    required this.schoolName,
    required this.governorate,
    required this.educationalAdministration,
    required this.examTitle,
    required this.academicYear,
    required this.termName,
    required this.examDuration,
    required this.totalGrade,
    required this.examTemplate,
    required this.includeAnswerSpaces,
    required this.fontSize,
  });

  bool get isBooklet => paperType == PaperType.booklet;

  int get questionsCount {
    return sections.fold(
      0,
      (total, section) => total + section.questions.length,
    );
  }

  @override
  List<Object?> get props => [
    gradeTitle,
    subjectTitle,
    paperType,
    sections,
    bookletTitle,
    teacherName,
    teacherPhoneNumber,
    bookletTemplate,
    includeBookletAnswers,
    schoolName,
    governorate,
    educationalAdministration,
    examTitle,
    academicYear,
    termName,
    examDuration,
    totalGrade,
    examTemplate,
    includeAnswerSpaces,
    fontSize,
  ];
}
