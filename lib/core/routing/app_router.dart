import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waraqty/core/constants/app_routes.dart';
import 'package:waraqty/features/document_builder/data/services/egyptian_pdf_generator.dart';
import 'package:waraqty/features/document_builder/data/services/pdf_storage_service.dart';
import 'package:waraqty/features/document_builder/presentation/cubit/document_builder_cubit.dart';
import 'package:waraqty/features/document_builder/presentation/cubit/document_details_cubit.dart';
import 'package:waraqty/features/document_builder/presentation/mappers/document_data_mapper.dart';
import 'package:waraqty/features/document_builder/presentation/screens/document_details_screen.dart';
import 'package:waraqty/features/document_builder/presentation/screens/pdf_preview_screen.dart';
import 'package:waraqty/features/document_builder/presentation/screens/saved_success_screen.dart';
import 'package:waraqty/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:waraqty/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:waraqty/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:waraqty/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:waraqty/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:waraqty/features/paper_setup/presentation/cubit/paper_setup_cubit.dart';
import 'package:waraqty/features/paper_setup/presentation/screens/grade_selection_screen.dart';
import 'package:waraqty/features/paper_setup/presentation/screens/paper_type_screen.dart';
import 'package:waraqty/features/paper_setup/presentation/screens/subject_selection_screen.dart';
import 'package:waraqty/features/question_bank/data/datasources/local_datasource/question_bank_local_data_source.dart';
import 'package:waraqty/features/question_bank/data/repositories/question_bank_repository_impl.dart';
import 'package:waraqty/features/question_bank/domain/usecases/get_question_categories_use_case.dart';
import 'package:waraqty/features/question_bank/domain/usecases/get_questions_by_filter_use_case.dart';
import 'package:waraqty/features/question_bank/presentation/cubit/question_selection_cubit.dart';
import 'package:waraqty/features/question_bank/presentation/screens/document_summary/document_summary_screen.dart';
import 'package:waraqty/features/question_bank/presentation/screens/question_selection/question_selection_screen.dart';

class AppRouter {
  final bool hasSeenOnboarding;
  final SharedPreferences sharedPreferences;

  AppRouter({required this.hasSeenOnboarding, required this.sharedPreferences});

  GoRouter get router => GoRouter(
    initialLocation: hasSeenOnboarding
        ? AppRoutes.gradeSelection
        : AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => BlocProvider(
          create: (context) => OnboardingCubit(
            completeOnboardingUseCase: CompleteOnboardingUseCase(
              repository: OnboardingRepositoryImpl(
                localDataSource: OnboardingLocalDataSource(
                  sharedPreferences: sharedPreferences,
                ),
              ),
            ),
          ),
          child: OnboardingScreen(),
        ),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => PaperSetupCubit(),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.gradeSelection,
            builder: (context, state) => const GradeSelectionScreen(),
          ),
          GoRoute(
            path: AppRoutes.subjectSelection,
            builder: (context, state) => const SubjectSelectionScreen(),
          ),
          GoRoute(
            path: AppRoutes.documentType,
            builder: (context, state) => const PaperTypeScreen(),
          ),
          ShellRoute(
            builder: (context, state, child) {
              final paperSetupState = context.read<PaperSetupCubit>().state;
              if (!paperSetupState.isSetupComplete) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    context.go(AppRoutes.gradeSelection);
                  }
                });
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return BlocProvider(
                create: (context) {
                  final repository = QuestionBankRepositoryImpl(
                    localDataSource: QuestionBankLocalDataSourceImpl(),
                  );
                  return QuestionSelectionCubit(
                    getQuestionCategoriesUseCase: GetQuestionCategoriesUseCase(
                      repository: repository,
                    ),
                    getQuestionsByFilterUseCase: GetQuestionsByFilterUseCase(
                      repository: repository,
                    ),
                    selectedGrade: paperSetupState.selectedGrade!,
                    selectedSubject: paperSetupState.selectedSubject!,
                    selectedPaperType: paperSetupState.selectedPaperType!,
                  );
                },
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: AppRoutes.questionsSelection,
                builder: (context, state) => const QuestionSelectionScreen(),
              ),
              GoRoute(
                path: AppRoutes.documentSummary,
                builder: (context, state) => const DocumentSummaryScreen(),
              ),
              ShellRoute(
                builder: (context, state, child) {
                  return BlocProvider(
                    create: (context) => DocumentDetailsCubit(),
                    child: child,
                  );
                },
                routes: [
                  GoRoute(
                    path: AppRoutes.bookletDetails,
                    builder: (context, state) => const DocumentDetailsScreen(),
                  ),
                  GoRoute(
                    path: AppRoutes.examDetails,
                    builder: (context, state) => const DocumentDetailsScreen(),
                  ),
                  ShellRoute(
                    builder: (context, state, child) {
                      final documentData = DocumentDataMapper.fromCubits(
                        questionSelectionCubit: context
                            .read<QuestionSelectionCubit>(),
                        documentDetailsCubit: context
                            .read<DocumentDetailsCubit>(),
                      );
                      if (documentData == null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context.mounted) {
                            context.go(AppRoutes.questionsSelection);
                          }
                        });
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return BlocProvider(
                        create: (context) => DocumentBuilderCubit(
                          documentData: documentData,
                          pdfGenerator: EgyptianPdfGenerator(),
                          storageService: PdfStorageService(),
                        )..generate(),
                        child: child,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: AppRoutes.pdfPreview,
                        builder: (context, state) => const PdfPreviewScreen(),
                      ),
                      GoRoute(
                        path: AppRoutes.savedSuccess,
                        builder: (context, state) => const SavedSuccessScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
