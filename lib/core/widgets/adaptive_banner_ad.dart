import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:waraqty/core/ads/ads_cubit.dart';
import 'package:waraqty/core/ads/ads_state.dart';
import 'package:waraqty/core/ads/banner_ad_cubit.dart';
import 'package:waraqty/core/ads/banner_ad_state.dart';

class AdaptiveBannerAd extends StatelessWidget {
  const AdaptiveBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsCubit, AdsState>(
      buildWhen: (previous, current) {
        return previous.canRequestAds != current.canRequestAds;
      },
      builder: (context, adsState) {
        if (!adsState.canRequestAds) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.floor();
            if (availableWidth <= 0) return const SizedBox.shrink();

            return BlocProvider(
              create: (_) => BannerAdCubit()..load(availableWidth),
              child: const _BannerAdView(),
            );
          },
        );
      },
    );
  }
}

class _BannerAdView extends StatelessWidget {
  const _BannerAdView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerAdCubit, BannerAdState>(
      builder: (context, state) {
        final ad = state.ad;
        final size = state.size;
        if (state.status != BannerAdStatus.loaded ||
            ad == null ||
            size == null) {
          return const SizedBox.shrink();
        }

        return Center(
          child: SizedBox(
            width: size.width.toDouble(),
            height: size.height.toDouble(),
            child: AdWidget(ad: ad),
          ),
        );
      },
    );
  }
}
