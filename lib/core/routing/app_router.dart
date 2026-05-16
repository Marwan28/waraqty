import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:waraqty/core/constants/app_routes.dart';

class AppRouter {
  final bool hasSeenOnboarding;

  AppRouter({required this.hasSeenOnboarding});

  GoRouter get router => GoRouter(
    initialLocation: hasSeenOnboarding
        ? AppRoutes.gradeSelection
        : AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Onboarding Screen'))),
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
