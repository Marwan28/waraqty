import 'package:bloc/bloc.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/features/paper_setup/domain/entities/grade_entity.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';
import 'package:waraqty/features/paper_setup/domain/entities/subject_entity.dart';

part 'paper_setup_state.dart';

class PaperSetupCubit extends Cubit<PaperSetupState> {
  PaperSetupCubit() : super(const PaperSetupInitial());

  final List<GradeEntity> grades = const [
    GradeEntity(
      id: 'grade_4',
      title: GradeSelectionStrings.gradeFourTitle,
      subtitle: GradeSelectionStrings.socialStudiesOnly,
      gradeLevel: GradeSelectionStrings.gradeFourNumber,
      questionsCount: 200,
      subjectsCount: 1,
    ),
    GradeEntity(
      id: 'grade_5',
      title: GradeSelectionStrings.gradeFiveTitle,
      subtitle: GradeSelectionStrings.socialStudiesOnly,
      gradeLevel: GradeSelectionStrings.gradeFiveNumber,
      questionsCount: 200,
      subjectsCount: 1,
    ),
    GradeEntity(
      id: 'grade_6',
      title: GradeSelectionStrings.gradeSixTitle,
      subtitle: GradeSelectionStrings.socialStudiesOnly,
      gradeLevel: GradeSelectionStrings.gradeSixNumber,
      questionsCount: 200,
      subjectsCount: 1,
    ),
  ];

  final List<SubjectEntity> subjects = const [
    SubjectEntity(
      id: 'social_studies',
      title: PaperSetupStrings.socialStudiesTitle,
      statusLabel: PaperSetupStrings.availableNow,
      isAvailable: true,
      questionsCount: 200,
      questionsCountPrefix: PaperSetupStrings.questionsBankSubtitlePrefix,
      questionsCountSuffix: PaperSetupStrings.questionsBankSubtitleSuffix,
    ),
    SubjectEntity(
      id: 'arabic',
      title: PaperSetupStrings.arabicTitle,
      statusLabel: PaperSetupStrings.comingSoon,
      isAvailable: false,
      questionsCount: 0,
    ),
    SubjectEntity(
      id: 'math',
      title: PaperSetupStrings.mathTitle,
      statusLabel: PaperSetupStrings.comingSoon,
      isAvailable: false,
      questionsCount: 0,
    ),
    SubjectEntity(
      id: 'science',
      title: PaperSetupStrings.scienceTitle,
      statusLabel: PaperSetupStrings.comingSoon,
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
}
