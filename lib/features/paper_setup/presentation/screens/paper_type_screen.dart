import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:waraqty/core/constants/app_routes.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';
import 'package:waraqty/core/theme/app_spacing.dart';
import 'package:waraqty/features/paper_setup/domain/entities/paper_type_entity.dart';
import 'package:waraqty/features/paper_setup/presentation/cubit/paper_setup_cubit.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_setup_header.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/paper_type/paper_type_card.dart';

class PaperTypeScreen extends StatelessWidget {
  const PaperTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      body: SafeArea(
        child: BlocBuilder<PaperSetupCubit, PaperSetupState>(
          builder: (context, state) {
            if (!state.canOpenPaperTypeSelection) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;

                final fallbackRoute = state.canOpenSubjectSelection
                    ? AppRoutes.subjectSelection
                    : AppRoutes.gradeSelection;
                context.go(fallbackRoute);
              });
            }

            final cubit = context.read<PaperSetupCubit>();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaperSetupHeader(
                  step: PaperTypesStrings.step3Of3,
                  title: PaperTypesStrings.selectPaperTypeTitle,
                  subtitle: PaperTypesStrings.selectPaperTypeSubtitle,
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
                      itemCount: cubit.paperTypes.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final paperType = cubit.paperTypes[index];
                        final isSelected =
                            state.selectedPaperType?.id == paperType.id;

                        return PaperTypeCard(
                          paperType: paperType,
                          isSelected: isSelected,
                          onTap: () => _selectPaperType(context, paperType),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSpacing.xl.h),
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

  void _selectPaperType(BuildContext context, PaperTypeEntity paperType) {
    context.read<PaperSetupCubit>().selectPaperType(paperType);
    context.push(AppRoutes.questionsSelection);
  }
}
