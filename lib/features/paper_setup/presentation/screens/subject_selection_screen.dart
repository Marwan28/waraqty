import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:waraqty/core/constants/app_routes.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/features/paper_setup/domain/entities/subject_entity.dart';
import 'package:waraqty/features/paper_setup/presentation/cubit/paper_setup_cubit.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_setup_header.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/subject_selection/subject_card.dart';

class SubjectSelectionScreen extends StatelessWidget {
  const SubjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      body: SafeArea(
        child: BlocBuilder<PaperSetupCubit, PaperSetupState>(
          builder: (context, state) {
            if (!state.canOpenSubjectSelection) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  context.go(AppRoutes.gradeSelection);
                }
              });
            }

            final cubit = context.read<PaperSetupCubit>();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaperSetupHeader(
                  step: SubjectSelectionStrings.step2Of3,
                  title: SubjectSelectionStrings.selectSubjectTitle,
                  subtitle: SubjectSelectionStrings.selectSubjectSubtitle,
                  onBackPressed: context.pop,
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
                      itemCount: cubit.subjects.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final subject = cubit.subjects[index];
                        final isSelected =
                            state.selectedSubject?.id == subject.id;

                        return SubjectCard(
                          subject: subject,
                          isSelected: isSelected,
                          onTap: subject.isAvailable
                              ? () => _selectSubject(context, subject)
                              : null,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSpacing.lg.h),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _selectSubject(BuildContext context, SubjectEntity subject) {
    context.read<PaperSetupCubit>().selectSubject(subject);
    context.push(AppRoutes.documentType);
  }
}
