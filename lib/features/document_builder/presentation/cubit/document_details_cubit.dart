import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'document_details_state.dart';

class DocumentDetailsCubit extends Cubit<DocumentDetailsState> {
  DocumentDetailsCubit() : super(const DocumentDetailsState());

  void updateBookletTitle(String value) {
    emit(state.copyWith(bookletTitle: value.trim()));
  }

  void updateTeacherName(String value) {
    emit(state.copyWith(teacherName: value.trim()));
  }

  void updateTeacherPhoneNumber(String value) {
    emit(state.copyWith(teacherPhoneNumber: value.trim()));
  }

  void updateSubjectName(String value) {
    emit(state.copyWith(subjectName: value.trim()));
  }

  void updateBookletTemplate(String value) {
    emit(state.copyWith(bookletTemplate: value));
  }

  void updateFontSize(double value) {
    emit(state.copyWith(fontSize: value));
  }

  void toggleBookletAnswers(bool value) {
    emit(state.copyWith(includeBookletAnswers: value));
  }

  void updateSchoolName(String value) {
    emit(state.copyWith(schoolName: value.trim()));
  }

  void updateGovernorate(String value) {
    emit(state.copyWith(governorate: value.trim()));
  }

  void updateEducationalAdministration(String value) {
    emit(state.copyWith(educationalAdministration: value.trim()));
  }

  void updateExamTitle(String value) {
    emit(state.copyWith(examTitle: value.trim()));
  }

  void updateAcademicYear(String value) {
    emit(state.copyWith(academicYear: value.trim()));
  }

  void updateTermName(String value) {
    emit(state.copyWith(termName: value.trim()));
  }

  void updateExamDuration(String value) {
    emit(state.copyWith(examDuration: value.trim()));
  }

  void updateTotalGrade(String value) {
    emit(state.copyWith(totalGrade: value.trim()));
  }

  void toggleAnswerSpaces(bool value) {
    emit(state.copyWith(includeAnswerSpaces: value));
  }
}
