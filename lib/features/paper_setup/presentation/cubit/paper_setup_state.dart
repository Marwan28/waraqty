part of 'paper_setup_cubit.dart';

class PaperSetupState extends Equatable {
  final GradeEntity? selectedGrade;
  final SubjectEntity? selectedSubject;
  final PaperTypeEntity? selectedPaperType;

  const PaperSetupState({
    this.selectedGrade,
    this.selectedSubject,
    this.selectedPaperType,
  });

  bool get hasSelectedGrade => selectedGrade != null;

  bool get hasSelectedSubject => selectedSubject != null;

  bool get hasSelectedPaperType => selectedPaperType != null;

  bool get canOpenSubjectSelection => hasSelectedGrade;

  bool get canOpenPaperTypeSelection => hasSelectedGrade && hasSelectedSubject;

  bool get isSetupComplete =>
      hasSelectedGrade && hasSelectedSubject && hasSelectedPaperType;

  PaperSetupState copyWith({
    GradeEntity? selectedGrade,
    SubjectEntity? selectedSubject,
    PaperTypeEntity? selectedPaperType,
  }) {
    return PaperSetupState(
      selectedGrade: selectedGrade ?? this.selectedGrade,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      selectedPaperType: selectedPaperType ?? this.selectedPaperType,
    );
  }

  PaperSetupState clearSelections() {
    return PaperSetupState(
      selectedGrade: null,
      selectedSubject: null,
      selectedPaperType: null,
    );
  }

  @override
  List<Object?> get props => [
    selectedGrade,
    selectedSubject,
    selectedPaperType,
  ];
}
