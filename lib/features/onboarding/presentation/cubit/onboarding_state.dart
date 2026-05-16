part of 'onboarding_cubit.dart';

sealed class OnboardingState {
  final int currentPageIndex;

  const OnboardingState({required this.currentPageIndex});
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial() : super(currentPageIndex: 0);
}

class OnboardingPageChanged extends OnboardingState {
  final int pageIndex;

  const OnboardingPageChanged({required this.pageIndex})
    : super(currentPageIndex: pageIndex);
}

class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted({required super.currentPageIndex});
}

// final class OnboardingLoading extends OnboardingState {}
// final class OnboardingSuccess extends OnboardingState {}
// final class OnboardingFailure extends OnboardingState {
//   final String errorMessage;
//   OnboardingFailure({required this.errorMessage});
// }
