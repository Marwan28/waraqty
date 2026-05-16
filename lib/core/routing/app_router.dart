import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waraqty/core/constants/app_routes.dart';
import 'package:waraqty/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:waraqty/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:waraqty/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:waraqty/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:waraqty/features/onboarding/presentation/screens/onboarding_screen.dart';

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
      GoRoute(
        path: AppRoutes.gradeSelection,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Grade Selection Screen'))),
      ),
      GoRoute(
        path: AppRoutes.subjectSelection,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Subject Selection Screen')),
        ),
      ),
      GoRoute(
        path: AppRoutes.documentType,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Document Type Screen'))),
      ),
      GoRoute(
        path: AppRoutes.questionSelection,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Question Selection Screen')),
        ),
      ),
      GoRoute(
        path: AppRoutes.documentSummary,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Document Summary Screen')),
        ),
      ),
      GoRoute(
        path: AppRoutes.bookletDetails,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Booklet Details Screen'))),
      ),
      GoRoute(
        path: AppRoutes.examDetails,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Exam Details Screen'))),
      ),
      GoRoute(
        path: AppRoutes.pdfPreview,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Pdf Preview Screen'))),
      ),
      GoRoute(
        path: AppRoutes.savedSuccess,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Saved Success Screen'))),
      ),
    ],
  );
}
