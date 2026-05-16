import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:waraqty/features/onboarding/presentation/models/onboarding_page_data.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required this.completeOnboardingUseCase})
    : super(OnboardingInitial());
  final CompleteOnboardingUseCase completeOnboardingUseCase;
  final List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: OnboardingStrings.title1,
      description: OnboardingStrings.description1,
      icon: LucideIcons.graduationCap,
      iconBackgroundColor: const Color(AppColors.primarySoft),
      iconColor: const Color(AppColors.primary),
    ),
    OnboardingPageData(
      title: OnboardingStrings.title2,
      description: OnboardingStrings.description2,
      icon: LucideIcons.listChecks,
      iconBackgroundColor: const Color(AppColors.primarySoft),
      iconColor: const Color(AppColors.primary),
    ),
    OnboardingPageData(
      title: OnboardingStrings.title3,
      description: OnboardingStrings.description3,
      icon: LucideIcons.fileCheck,
      iconBackgroundColor: const Color(AppColors.primarySoft),
      iconColor: const Color(AppColors.primary),
    ),
  ];

  void changePage(int pageIndex) {
    emit(OnboardingPageChanged(pageIndex: pageIndex));
  }

  Future<void> completeOnboarding() async {
    await completeOnboardingUseCase();
    emit(OnboardingCompleted(currentPageIndex: state.currentPageIndex));
  }
}
