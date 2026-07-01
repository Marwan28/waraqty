import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum BannerAdStatus { initial, loading, loaded, failed }

class BannerAdState extends Equatable {
  final BannerAdStatus status;
  final BannerAd? ad;
  final AdSize? size;

  const BannerAdState({
    this.status = BannerAdStatus.initial,
    this.ad,
    this.size,
  });

  const BannerAdState.loading() : this(status: BannerAdStatus.loading);

  const BannerAdState.loaded({required BannerAd ad, required AdSize size})
    : this(status: BannerAdStatus.loaded, ad: ad, size: size);

  const BannerAdState.failed() : this(status: BannerAdStatus.failed);

  @override
  List<Object?> get props => [status, ad, size];
}
