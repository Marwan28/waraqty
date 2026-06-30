import 'package:waraqty/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:waraqty/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> hasSeenOnboarding() {
    return  localDataSource.hasSeenOnboarding();
  }

  @override
  Future<void> setOnboardingSeen()   {
     return localDataSource.setOnboardingSeen();
  }
}
