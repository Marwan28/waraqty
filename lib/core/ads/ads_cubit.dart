import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waraqty/core/ads/ad_ids.dart';
import 'package:waraqty/core/ads/ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  static const String _pdfSaveCountKey = 'successful_pdf_save_count';
  static const int _interstitialFrequency = 1;

  final SharedPreferences sharedPreferences;

  InterstitialAd? _interstitialAd;
  bool _isMobileAdsInitialized = false;
  bool _isLoadingInterstitial = false;

  AdsCubit({required this.sharedPreferences}) : super(const AdsState());

  Future<void> initialize() async {
    if (state.status != AdsStatus.initial) return;

    emit(state.copyWith(status: AdsStatus.requestingConsent));
    final completer = Completer<void>();

    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
         ConsentRequestParameters(),
        () => _handleConsentUpdateSuccess(completer),
        (error) {
          _finishConsentFlow(
            errorMessage: error.message,
          ).whenComplete(() => _complete(completer));
        },
      );
    } catch (error) {
      await _finishConsentFlow(errorMessage: error.toString());
      _complete(completer);
    }

    return completer.future;
  }

  Future<void> showPrivacyOptions() async {
    await ConsentForm.showPrivacyOptionsForm((error) {});
    await _finishConsentFlow();
  }

  Future<void> registerSuccessfulPdfSave() async {
    final nextCount = (sharedPreferences.getInt(_pdfSaveCountKey) ?? 0) + 1;

    if (nextCount < _interstitialFrequency) {
      await sharedPreferences.setInt(_pdfSaveCountKey, nextCount);
      return;
    }

    await sharedPreferences.setInt(_pdfSaveCountKey, 0);
    await _showInterstitialIfAvailable();
  }

  Future<void> _handleConsentUpdateSuccess(Completer<void> completer) async {
    String errorMessage = '';

    try {
      await ConsentForm.loadAndShowConsentFormIfRequired((error) {
        errorMessage = error?.message ?? '';
      });
    } catch (error) {
      errorMessage = error.toString();
    }

    await _finishConsentFlow(errorMessage: errorMessage);
    _complete(completer);
  }

  Future<void> _finishConsentFlow({String errorMessage = ''}) async {
    bool canRequestAds = false;
    bool privacyOptionsRequired = false;

    try {
      canRequestAds = await ConsentInformation.instance.canRequestAds();
      final privacyStatus = await ConsentInformation.instance
          .getPrivacyOptionsRequirementStatus();
      privacyOptionsRequired =
          privacyStatus == PrivacyOptionsRequirementStatus.required;

      if (canRequestAds && !_isMobileAdsInitialized) {
        await MobileAds.instance.initialize();
        _isMobileAdsInitialized = true;
      }
    } catch (error) {
      errorMessage = errorMessage.isEmpty ? error.toString() : errorMessage;
    }

    if (isClosed) return;

    emit(
      AdsState(
        status: AdsStatus.ready,
        canRequestAds: canRequestAds,
        privacyOptionsRequired: privacyOptionsRequired,
        errorMessage: errorMessage,
      ),
    );

    if (canRequestAds) {
      _loadInterstitial();
    } else {
      _interstitialAd?.dispose();
      _interstitialAd = null;
    }
  }

  void _loadInterstitial() {
    if (!_isMobileAdsInitialized ||
        _isLoadingInterstitial ||
        _interstitialAd != null) {
      return;
    }

    _isLoadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoadingInterstitial = false;
          if (isClosed || !state.canRequestAds) {
            ad.dispose();
            return;
          }
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _isLoadingInterstitial = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  Future<void> _showInterstitialIfAvailable() async {
    final ad = _interstitialAd;
    _interstitialAd = null;

    if (ad == null || !state.canRequestAds) {
      _loadInterstitial();
      return;
    }

    final completer = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (shownAd) {
        shownAd.dispose();
        _loadInterstitial();
        _complete(completer);
      },
      onAdFailedToShowFullScreenContent: (shownAd, error) {
        shownAd.dispose();
        _loadInterstitial();
        _complete(completer);
      },
    );

    try {
      ad.show();
      await completer.future;
    } catch (_) {
      ad.dispose();
      _loadInterstitial();
      _complete(completer);
    }
  }

  void _complete(Completer<void> completer) {
    if (!completer.isCompleted) completer.complete();
  }

  @override
  Future<void> close() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    return super.close();
  }
}
