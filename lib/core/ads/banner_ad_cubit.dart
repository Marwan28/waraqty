import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:waraqty/core/ads/ad_ids.dart';
import 'package:waraqty/core/ads/banner_ad_state.dart';

class BannerAdCubit extends Cubit<BannerAdState> {
  BannerAdCubit() : super(const BannerAdState());

  Future<void> load(int availableWidth) async {
    if (availableWidth <= 0 || state.status != BannerAdStatus.initial) return;

    emit(const BannerAdState.loading());
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      availableWidth,
    );

    if (size == null || isClosed) {
      if (!isClosed) emit(const BannerAdState.failed());
      return;
    }

    late final BannerAd ad;
    ad = BannerAd(
      adUnitId: AdIds.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (loadedAd) {
          if (isClosed) {
            loadedAd.dispose();
            return;
          }
          emit(BannerAdState.loaded(ad: ad, size: size));
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();
          if (!isClosed) emit(const BannerAdState.failed());
        },
      ),
    );

    await ad.load();
  }

  @override
  Future<void> close() {
    state.ad?.dispose();
    return super.close();
  }
}
