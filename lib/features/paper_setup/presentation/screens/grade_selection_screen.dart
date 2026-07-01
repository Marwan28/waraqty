import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:waraqty/core/constants/app_routes.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/core/widgets/privacy_options_button.dart';
import 'package:waraqty/features/paper_setup/domain/entities/grade_entity.dart';
import 'package:waraqty/features/paper_setup/presentation/cubit/paper_setup_cubit.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/grade_selection/grade_card.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_setup_header.dart';

class GradeSelectionScreen extends StatelessWidget {
  const GradeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      body: SafeArea(
        child: BlocBuilder<PaperSetupCubit, PaperSetupState>(
          builder: (context, state) {
            final cubit = context.read<PaperSetupCubit>();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PaperSetupHeader(
                  step: GradeSelectionStrings.step1Of3,
                  title: GradeSelectionStrings.selectGradeTitle,
                  subtitle: GradeSelectionStrings.selectGradeSubtitle,
                ),
                Divider(
                  height: 1.h,
                  thickness: 1.h,
                  color: const Color(AppColors.border),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontalPadding.w,
                      vertical: AppSpacing.xl.h,
                    ),
                    child: ListView.separated(
                      itemCount: cubit.grades.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final grade = cubit.grades[index];
                        final isSelected = state.selectedGrade?.id == grade.id;

                        return GradeCard(
                          grade: grade,
                          isSelected: isSelected,
                          onTap: () => _selectGrade(context, grade),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSpacing.lg.h),
                    ),
                  ),
                ),
                const PrivacyOptionsButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _selectGrade(BuildContext context, GradeEntity grade) {
    context.read<PaperSetupCubit>().selectGrade(grade);
    context.push(AppRoutes.subjectSelection);
  }
}
