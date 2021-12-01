import 'package:flutter/services.dart';

import 'nend_plugin.dart';
import 'video.dart';

/// Create a RewardedVideoAd.
class RewardedVideoAd extends VideoAd {
  static const tag = 'NendAdRewardedVideo';

  factory RewardedVideoAd({required int spotId, required String apiKey}) {
    return _rewardedVideo ??= RewardedVideoAd._(
      spotId: spotId,
      apiKey: apiKey,
    );
  }

  RewardedVideoAd._({required int spotId, required String apiKey}) {
    adType = tag;
    init(spotId: spotId, apiKey: apiKey);
  }

  static RewardedVideoAd? _rewardedVideo;

  @override
  Future<void> releaseAd() async {
    super.releaseAd();
    _rewardedVideo = null;
  }

  void setEventListener(RewardedVideoAdListener listener) {
    channel.setMethodCallHandler(
      (call) => _handler(listener: listener, call: call),
    );
  }

  Future<void> _handler({
    required RewardedVideoAdListener listener,
    required MethodCall call,
  }) async {
    switch (call.method) {
      case 'onRewarded':
        listener.onRewarded(call.arguments);
        break;
      case 'onLoaded':
        final onLoaded = listener.onLoaded;
        if (onLoaded != null) {
          onLoaded();
        }
        break;
      case 'onFailedToLoad':
        final onFailedToLoad = listener.onFailedToLoad;
        if (onFailedToLoad != null) {
          onFailedToLoad();
        }
        break;
      case 'onFailedToPlay':
        final onFailedToPlay = listener.onFailedToPlay;
        if (onFailedToPlay != null) {
          onFailedToPlay();
        }
        break;
      case 'onShown':
        final onShown = listener.onShown;
        if (onShown != null) {
          onShown();
        }
        break;
      case 'onClosed':
        final onClosed = listener.onClosed;
        if (onClosed != null) {
          onClosed();
        }
        break;
      case 'onStarted':
        final onStarted = listener.onStarted;
        if (onStarted != null) {
          onStarted();
        }
        break;
      case 'onStopped':
        final onStopped = listener.onStopped;
        if (onStopped != null) {
          onStopped();
        }
        break;
      case 'onCompleted':
        final onCompleted = listener.onCompleted;
        if (onCompleted != null) {
          onCompleted();
        }
        break;
      case 'onAdClicked':
        final onAdClicked = listener.onAdClicked;
        if (onAdClicked != null) {
          onAdClicked();
        }
        break;
      case 'onInformationClicked':
        final onInformationClicked = listener.onInformationClicked;
        if (onInformationClicked != null) {
          onInformationClicked();
        }
        break;
      case 'onDetectedVideoType':
        detectVideoType(call.arguments);
        break;
    }
  }
}

/// Can receive these events for the RewardedVideoAd.
class RewardedVideoAdListener {
  RewardedVideoAdListener({
    required this.onRewarded,
    this.onLoaded,
    this.onFailedToLoad,
    this.onFailedToPlay,
    this.onShown,
    this.onClosed,
    this.onStarted,
    this.onStopped,
    this.onCompleted,
    this.onAdClicked,
    this.onInformationClicked,
  });

  /// Called when received reward item.
  /// This argument have a currency's name and a currency's amount.
  /// Usage:
  /// ```Dart
  /// onRewarded: (arg) {
  ///   reward = (arg as Map)['reward'];
  ///   final name = reward['name'];
  ///   final amount = reward['amount'];
  ///
  ///   ...
  /// },
  /// ```
  final AdEventCallBackUseArgument onRewarded;

  /// Called when successfully loaded the RewardedVideoAd.
  final AdEventCallBack? onLoaded;

  /// Called when failed to load the RewardedVideoAd.
  final AdEventCallBack? onFailedToLoad;

  /// Called when failed to play the RewardedVideoAd.
  final AdEventCallBack? onFailedToPlay;

  /// Called when successfully displayed the RewardedVideoAd.
  final AdEventCallBack? onShown;

  /// Called when the RewardedVideoAd closed.
  final AdEventCallBack? onClosed;

  /// Called when started playing the video.
  final AdEventCallBack? onStarted;

  /// Called when stopped playing the video.
  final AdEventCallBack? onStopped;

  /// Called when completed playing the video.
  final AdEventCallBack? onCompleted;

  /// Called when the RewardedVideoAd clicked.
  final AdEventCallBack? onAdClicked;

  /// Called when the information button clicked.
  final AdEventCallBack? onInformationClicked;
}
