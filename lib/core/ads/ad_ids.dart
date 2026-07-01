import 'package:flutter/foundation.dart';

abstract final class AdIds {
  static const String _productionBannerAndroid =
      'ca-app-pub-6197277342066951/1774048991';
  static const String _productionInterstitialAndroid =
      'ca-app-pub-6197277342066951/5611588741';

  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';

  static String get banner {
    if (!kReleaseMode || defaultTargetPlatform != TargetPlatform.android) {
      return _testBannerAndroid;
    }
    return _productionBannerAndroid;
  }

  static String get interstitial {
    if (!kReleaseMode || defaultTargetPlatform != TargetPlatform.android) {
      return _testInterstitialAndroid;
    }
    return _productionInterstitialAndroid;
  }
}
