import 'package:waraqty/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository repository;

  CompleteOnboardingUseCase({required this.repository});
  Future<void> call() async {
    await repository.setOnboardingSeen();
  }
}
