import 'package:flutter/services.dart';

import 'nend_plugin.dart';
import 'video.dart';

/// Create a InterstitialVideoAd.
class InterstitialVideoAd extends VideoAd {
  factory InterstitialVideoAd({required int spotId, required String apiKey}) {
    return _interstitialVideo ??= InterstitialVideoAd.create(
        spotId: spotId,
        apiKey: apiKey,
        methodChannel: MethodChannel(
            'nend_plugin/NendAdInterstitialVideo', JSONMethodCodec()));
  }

  InterstitialVideoAd.create(
      {required int spotId,
      required String apiKey,
      required MethodChannel methodChannel}) {
    this.methodChannel = methodChannel;
    init(spotId: spotId, apiKey: apiKey);
  }

  static InterstitialVideoAd? _interstitialVideo;

  @override
  Future<void> releaseAd() async {
    super.releaseAd();
    _interstitialVideo = null;
  }

  /// If can not display the InterstitialVideoAd for reasons such as out of stock, can display FullscreenAd instead.
  /// In order to use this function, you need to register ad space of fullscreen ads separately on nend console.
  Future<void> addFallbackFullboard({
    required int spotId,
    required String apiKey,
  }) async {
    await NendPlugin.invokeMethod(
      channel: methodChannel,
      method: 'addFallbackFullboard',
      argument: {
        NendPlugin.key_spot_id: spotId,
        NendPlugin.key_api_key: apiKey
      },
    );
  }

  /// Set mute to play the InterstitialVideoAd.
  /// The default value is true.
  set muteStartPlaying(bool muteStartPlaying) {
    NendPlugin.invokeMethod(
      channel: methodChannel,
      method: 'muteStartPlaying',
      argument: {'muteStartPlaying': muteStartPlaying},
    );
  }

  void setEventListener(InterstitialVideoAdListener listener) {
    methodChannel.setMethodCallHandler(
      (call) => _handler(listener: listener, call: call),
    );
  }

  Future<void> _handler({
    required InterstitialVideoAdListener listener,
    required MethodCall call,
  }) async {
    switch (call.method) {
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

/// Can receive these events for the InterstitialVideoAd.
class InterstitialVideoAdListener {
  InterstitialVideoAdListener({
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

  /// Called when successfully loaded the InterstitialVideoAd.
  final AdEventCallBack? onLoaded;

  /// Called when failed to load the InterstitialVideoAd.
  final AdEventCallBack? onFailedToLoad;

  /// Called when failed to play the InterstitialVideoAd.
  final AdEventCallBack? onFailedToPlay;

  /// Called when successfully displayed the InterstitialVideoAd.
  final AdEventCallBack? onShown;

  /// Called when the InterstitialVideoAd closed.
  final AdEventCallBack? onClosed;

  /// Called when started playing the video.
  final AdEventCallBack? onStarted;

  /// Called when stopped playing the video.
  final AdEventCallBack? onStopped;

  /// Called when completed playing the video.
  final AdEventCallBack? onCompleted;

  /// Called when the InterstitialVideoAd clicked.
  final AdEventCallBack? onAdClicked;

  /// Called when the information button clicked.
  final AdEventCallBack? onInformationClicked;
}
