import 'package:equatable/equatable.dart';

enum AdsStatus { initial, requestingConsent, ready }

class AdsState extends Equatable {
  final AdsStatus status;
  final bool canRequestAds;
  final bool privacyOptionsRequired;
  final String errorMessage;

  const AdsState({
    this.status = AdsStatus.initial,
    this.canRequestAds = false,
    this.privacyOptionsRequired = false,
    this.errorMessage = '',
  });

  AdsState copyWith({
    AdsStatus? status,
    bool? canRequestAds,
    bool? privacyOptionsRequired,
    String? errorMessage,
  }) {
    return AdsState(
      status: status ?? this.status,
      canRequestAds: canRequestAds ?? this.canRequestAds,
      privacyOptionsRequired:
          privacyOptionsRequired ?? this.privacyOptionsRequired,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    canRequestAds,
    privacyOptionsRequired,
    errorMessage,
  ];
}
