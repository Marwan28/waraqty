import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:waraqty/core/constants/app_routes.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/theme/app_text_styles.dart';
import 'package:waraqty/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:waraqty/features/onboarding/presentation/widgets/onboarding_action_button.dart';
import 'package:waraqty/features/onboarding/presentation/widgets/onboarding_page_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(OnboardingState state) {
    final cubit = context.read<OnboardingCubit>();
    final isLastPage = state.currentPageIndex == cubit.pages.length - 1;

    if (isLastPage) {
      _skipOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _skipOnboarding() {
    context.read<OnboardingCubit>().completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.go(AppRoutes.gradeSelection);
        }
      },
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        final isLastPage = state.currentPageIndex == cubit.pages.length - 1;

        return Scaffold(
          backgroundColor: const Color(AppColors.background),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontalPadding.w,
                vertical: AppSpacing.screenVerticalPadding.h,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _skipOnboarding,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(AppColors.textSecondary),
                          minimumSize: Size.zero,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          OnboardingStrings.skip,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(AppColors.textSecondary),
                          ),
                        ),
                      ),
                      Text(
                        AppStrings.appName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: const Color(AppColors.textPrimary),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: cubit.pages.length,
                      onPageChanged: cubit.changePage,
                      itemBuilder: (context, index) {
                        return OnboardingPageItem(data: cubit.pages[index]);
                      },
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: cubit.pages.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 6.h,
                      dotWidth: 6.w,
                      spacing: 6.w,
                      expansionFactor: 3,
                      activeDotColor: const Color(AppColors.primary),
                      dotColor: const Color(AppColors.border),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  OnboardingActionButton(
                    isLastPage: isLastPage,
                    onPressed: () => _nextPage(state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

