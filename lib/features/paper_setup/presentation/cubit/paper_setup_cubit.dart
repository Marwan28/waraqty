import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/features/paper_setup/domain/entities/grade_entity.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';
import 'package:waraqty/features/paper_setup/domain/entities/subject_entity.dart';

part 'paper_setup_state.dart';

class PaperSetupCubit extends Cubit<PaperSetupState> {
  PaperSetupCubit() : super(const PaperSetupState());

  final List<GradeEntity> grades = const [
    GradeEntity(
      id: 'grade_4',
      title: GradeSelectionStrings.gradeFourTitle,
      subtitle: GradeSelectionStrings.socialStudiesOnly,
      gradeLevel: GradeSelectionStrings.gradeFourNumber,
      questionsCount: 240,
      subjectsCount: 1,
    ),
    GradeEntity(
      id: 'grade_5',
      title: GradeSelectionStrings.gradeFiveTitle,
      subtitle: GradeSelectionStrings.socialStudiesOnly,
      gradeLevel: GradeSelectionStrings.gradeFiveNumber,
      questionsCount: 312,
      subjectsCount: 1,
    ),
    GradeEntity(
      id: 'grade_6',
      title: GradeSelectionStrings.gradeSixTitle,
      subtitle: GradeSelectionStrings.socialStudiesOnly,
      gradeLevel: GradeSelectionStrings.gradeSixNumber,
      questionsCount: 286,
      subjectsCount: 1,
    ),
  ];

  final List<SubjectEntity> subjects = const [
    SubjectEntity(
      id: 'social_studies',
      title: SubjectSelectionStrings.socialStudiesTitle,
      statusLabel: SubjectSelectionStrings.availableNow,
      isAvailable: true,
      questionsCount: 280,
      questionsCountPrefix: SubjectSelectionStrings.questionsBankSubtitlePrefix,
      questionsCountSuffix: SubjectSelectionStrings.questionsBankSubtitleSuffix,
    ),
    SubjectEntity(
      id: 'arabic',
      title: SubjectSelectionStrings.arabicTitle,
      statusLabel: SubjectSelectionStrings.comingSoon,
      isAvailable: false,
      questionsCount: 0,
    ),
    SubjectEntity(
      id: 'math',
      title: SubjectSelectionStrings.mathTitle,
      statusLabel: SubjectSelectionStrings.comingSoon,
      isAvailable: false,
      questionsCount: 0,
    ),
    SubjectEntity(
      id: 'science',
      title: SubjectSelectionStrings.scienceTitle,
      statusLabel: SubjectSelectionStrings.comingSoon,
      isAvailable: false,
      questionsCount: 0,
    ),
  ];

  final List<PaperTypeEntity> paperTypes = const [
    PaperTypeEntity(
      id: 'booklet',
      type: PaperType.booklet,
      title: PaperTypesStrings.bookletTitle,
      subtitle: PaperTypesStrings.bookletSubtitle,
    ),
    PaperTypeEntity(
      id: 'exam',
      type: PaperType.exam,
      title: PaperTypesStrings.examTitle,
      subtitle: PaperTypesStrings.examSubtitle,
    ),
  ];

  void selectGrade(GradeEntity grade) {
    emit(
      PaperSetupState(
        selectedGrade: grade,
        selectedSubject: null,
        selectedPaperType: null,
      ),
    );
  }

  void selectSubject(SubjectEntity subject) {
    if (!state.canOpenSubjectSelection) return;
    if (!subject.isAvailable) return;

    emit(
      PaperSetupState(
        selectedGrade: state.selectedGrade,
        selectedSubject: subject,
        selectedPaperType: null,
      ),
    );
  }

  void selectPaperType(PaperTypeEntity paperType) {
    if (!state.canOpenPaperTypeSelection) return;
    emit(state.copyWith(selectedPaperType: paperType));
  }

  void resetSetup() {
    emit(state.clearSelections());
  }
}
