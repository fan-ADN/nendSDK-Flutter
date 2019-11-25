import 'package:flutter/services.dart';
import 'nend_plugin.dart';
import 'video.dart';

/// See for [details](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#interstitial-video-ad-implementation).
class InterstitialVideo extends Video {
  static const tag = 'NendAdInterstitialVideo';

  static InterstitialVideo _shared;
  factory InterstitialVideo(int spotId, String apiKey) {
    if (_shared == null) {
      _shared = new InterstitialVideo._internal(tag, spotId, apiKey);
    }
    return _shared;
  }
  InterstitialVideo._internal(tag, spotId, apiKey) : super(tag, spotId, apiKey);

  /// Release interstitial video ad. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#release-video-ad).
  @override
  void releaseAd() async {
    super.releaseAd();
    _shared = null;
  }

  /// Display fullscreen ads. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#display-fullscreen-ads).
  void addFallbackFullboard(int spotId, String apiKey) {
    invoke('.addFallbackFullboard', argument: adUnit(spotId, apiKey));
  }

  /// Set mute state to play video. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#set-mute-state-to-play-video).
  set muteStartPlaying(bool muteStartPlaying) {
    invoke('.muteStartPlaying',
        argument: {'muteStartPlaying': muteStartPlaying});
  }

  InterstitialVideoAdListener _listener;
  InterstitialVideoAdListener get listener => _listener;
  /// Register the listener to receive the ad event. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#register-event-listener).
  set listener(InterstitialVideoAdListener value) {
    _listener = value;
    NendPlugin.addListener(tag, this);
  }

  dynamic eventFrom(String type) {
    type = type.split(".").last;
    type = 'InterstitialVideoAdEvent.$type';
    return InterstitialVideoAdEvent.values
        .firstWhere((event) => event.toString() == type, orElse: () => null);
  }

  void notify(MethodCall call) {
    InterstitialVideoAdEvent event = eventFrom(call.method);
    if (event == InterstitialVideoAdEvent.onFailedToLoad) {
      Map<String, dynamic> map = call.arguments;
      int code = map[NendPlugin.key_error_code];
      listener(event, errorCode: code);
    } else {
      listener(event);
    }
  }
}

/// Receive the ad event. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#register-event-listener).
enum InterstitialVideoAdEvent {
  onLoaded,
  onFailedToLoad,
  onFailedToPlay,
  onShown,
  onStarted,
  onStopped,
  onCompleted,
  onInformationClicked,
  onAdClicked,
  onClosed
}

typedef void InterstitialVideoAdListener(InterstitialVideoAdEvent event,
    {int errorCode});
