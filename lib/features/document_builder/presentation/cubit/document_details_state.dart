part of 'document_details_cubit.dart';

class DocumentDetailsState extends Equatable {
  final String bookletTitle;
  final String teacherName;
  final String teacherPhoneNumber;
  final String subjectName;
  final String bookletTemplate;
  final double fontSize;
  final bool includeBookletAnswers;

  final String schoolName;
  final String governorate;
  final String educationalAdministration;
  final String examTitle;
  final String academicYear;
  final String termName;
  final String examDuration;
  final String totalGrade;
  final bool includeAnswerSpaces;

  const DocumentDetailsState({
    this.bookletTitle = '',
    this.teacherName = '',
    this.teacherPhoneNumber = '',
    this.subjectName = '',
    this.bookletTemplate = 'بسيط',
    this.fontSize = 14,
    this.includeBookletAnswers = false,
    this.schoolName = '',
    this.governorate = '',
    this.educationalAdministration = '',
    this.examTitle = '',
    this.academicYear = '',
    this.termName = '',
    this.examDuration = '',
    this.totalGrade = '',
    this.includeAnswerSpaces = true,
  });

  bool get hasBookletDetails {
    return bookletTitle.isNotEmpty ||
        teacherName.isNotEmpty ||
        teacherPhoneNumber.isNotEmpty ||
        subjectName.isNotEmpty;
  }

  bool get hasExamDetails {
    return schoolName.isNotEmpty ||
        governorate.isNotEmpty ||
        educationalAdministration.isNotEmpty ||
        examTitle.isNotEmpty ||
        academicYear.isNotEmpty ||
        termName.isNotEmpty ||
        subjectName.isNotEmpty ||
        examDuration.isNotEmpty ||
        totalGrade.isNotEmpty;
  }

  DocumentDetailsState copyWith({
    String? bookletTitle,
    String? teacherName,
    String? teacherPhoneNumber,
    String? subjectName,
    String? bookletTemplate,
    double? fontSize,
    bool? includeBookletAnswers,
    String? schoolName,
    String? governorate,
    String? educationalAdministration,
    String? examTitle,
    String? academicYear,
    String? termName,
    String? examDuration,
    String? totalGrade,
    bool? includeAnswerSpaces,
  }) {
    return DocumentDetailsState(
      bookletTitle: bookletTitle ?? this.bookletTitle,
      teacherName: teacherName ?? this.teacherName,
      teacherPhoneNumber: teacherPhoneNumber ?? this.teacherPhoneNumber,
      subjectName: subjectName ?? this.subjectName,
      bookletTemplate: bookletTemplate ?? this.bookletTemplate,
      fontSize: fontSize ?? this.fontSize,
      includeBookletAnswers:
          includeBookletAnswers ?? this.includeBookletAnswers,
      schoolName: schoolName ?? this.schoolName,
      governorate: governorate ?? this.governorate,
      educationalAdministration:
          educationalAdministration ?? this.educationalAdministration,
      examTitle: examTitle ?? this.examTitle,
      academicYear: academicYear ?? this.academicYear,
      termName: termName ?? this.termName,
      examDuration: examDuration ?? this.examDuration,
      totalGrade: totalGrade ?? this.totalGrade,
      includeAnswerSpaces: includeAnswerSpaces ?? this.includeAnswerSpaces,
    );
  }

  @override
  List<Object?> get props => [
    bookletTitle,
    teacherName,
    teacherPhoneNumber,
    subjectName,
    bookletTemplate,
    fontSize,
    includeBookletAnswers,
    schoolName,
    governorate,
    educationalAdministration,
    examTitle,
    academicYear,
    termName,
    examDuration,
    totalGrade,
    includeAnswerSpaces,
  ];
}
