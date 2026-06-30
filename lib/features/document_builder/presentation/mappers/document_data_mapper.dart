import 'package:waraqty/features/document_builder/domain/entities/document_data_entity.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_section_entity.dart';
import 'package:waraqty/features/document_builder/presentation/cubit/document_details_cubit.dart';
import 'package:waraqty/features/question_bank/presentation/cubit/question_selection_cubit.dart';

class DocumentDataMapper {
  const DocumentDataMapper._();

  static DocumentDataEntity? fromCubits({
    required QuestionSelectionCubit questionSelectionCubit,
    required DocumentDetailsCubit documentDetailsCubit,
  }) {
    final loadedState = _loadedState(questionSelectionCubit.state);
    if (loadedState == null || loadedState.allSelectedQuestions.isEmpty) {
      return null;
    }

    final details = documentDetailsCubit.state;
    final subjectTitle = details.subjectName.isEmpty
        ? questionSelectionCubit.selectedSubject.title
        : details.subjectName;

    final sections = loadedState.selectedQuestionsByCategory.entries
        .where((entry) => entry.value.isNotEmpty)
        .map(
          (entry) => DocumentSectionEntity(
            category: entry.key,
            questions: List.unmodifiable(entry.value),
          ),
        )
        .toList(growable: false);

    return DocumentDataEntity(
      gradeTitle: questionSelectionCubit.selectedGrade.title,
      subjectTitle: subjectTitle,
      paperType: questionSelectionCubit.selectedPaperType.type,
      sections: sections,
      bookletTitle: details.bookletTitle,
      teacherName: details.teacherName,
      teacherPhoneNumber: details.teacherPhoneNumber,
      bookletTemplate: details.bookletTemplate,
      includeBookletAnswers: details.includeBookletAnswers,
      schoolName: details.schoolName,
      governorate: details.governorate,
      educationalAdministration: details.educationalAdministration,
      examTitle: details.examTitle,
      academicYear: details.academicYear,
      termName: details.termName,
      examDuration: details.examDuration,
      totalGrade: details.totalGrade,
      examTemplate: details.examTemplate,
      includeAnswerSpaces: details.includeAnswerSpaces,
      fontSize: details.fontSize,
    );
  }

  static QuestionSelectionLoaded? _loadedState(QuestionSelectionState state) {
    if (state is QuestionSelectionLoaded) return state;
    if (state is QuestionSelectionLoading) return state.previousState;
    if (state is QuestionSelectionError) return state.previousState;
    return null;
  }
}
