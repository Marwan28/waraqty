import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/core/ads/ads_cubit.dart';
import 'package:waraqty/core/ads/ads_state.dart';
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/theme/app_colors.dart';

class PrivacyOptionsButton extends StatelessWidget {
  const PrivacyOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsCubit, AdsState>(
      buildWhen: (previous, current) {
        return previous.privacyOptionsRequired !=
            current.privacyOptionsRequired;
      },
      builder: (context, state) {
        if (!state.privacyOptionsRequired) return const SizedBox.shrink();

        return TextButton.icon(
          onPressed: context.read<AdsCubit>().showPrivacyOptions,
          icon: const Icon(LucideIcons.shieldCheck, size: 18),
          label: const Text(AdsStrings.privacyOptions),
          style: TextButton.styleFrom(
            foregroundColor: const Color(AppColors.primary),
          ),
        );
      },
    );
  }
}
