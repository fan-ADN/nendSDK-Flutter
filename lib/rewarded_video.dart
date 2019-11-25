import 'package:flutter/services.dart';
import 'nend_plugin.dart';
import 'video.dart';

/// See for [details](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#rewarded-video-ad-implementation).
class RewardedVideo extends Video {
  static const tag = 'NendAdRewardedVideo';

  static RewardedVideo _shared;
  factory RewardedVideo(int spotId, String apiKey) {
    if (_shared == null) {
      _shared = new RewardedVideo._internal(tag, spotId, apiKey);
    }
    return _shared;
  }
  RewardedVideo._internal(tag, spotId, apiKey) : super(tag, spotId, apiKey);

  /// Release rewarded video ad. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#release-video-ad-1).
  @override
  void releaseAd() async {
    super.releaseAd();
    _shared = null;
  }

  RewardedVideoAdListener _listener;
  RewardedVideoAdListener get listener => _listener;
  /// Register the listener to receive the ad event. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#register-event-listener-1).
  set listener(RewardedVideoAdListener value) {
    _listener = value;
    NendPlugin.addListener(tag, this);
  }

  dynamic eventFrom(String type) {
    type = type.split(".").last;
    type = 'RewardedVideoAdEvent.$type';
    return RewardedVideoAdEvent.values
        .firstWhere((event) => event.toString() == type, orElse: () => null);
  }

  void notify(MethodCall call) {
    RewardedVideoAdEvent event = eventFrom(call.method);
    if (event == RewardedVideoAdEvent.onFailedToLoad) {
      Map<String, dynamic> map = call.arguments;
      int code = map[NendPlugin.key_error_code];
      listener(event, errorCode: code);
    } else if (event == RewardedVideoAdEvent.onRewarded) {
      Map<String, dynamic> map = call.arguments;
      Map<String, dynamic> reward = map['reward'];
      listener(event,
          item: RewardedItem()
            ..currencyName = reward['currencyName']
            ..currencyAmount = reward['currencyAmount']);
    } else {
      listener(event);
    }
  }
}

/// Receive the ad event. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#register-event-listener-1).
enum RewardedVideoAdEvent {
  onLoaded,
  onFailedToLoad,
  onFailedToPlay,
  onShown,
  onStarted,
  onStopped,
  onCompleted,
  onInformationClicked,
  onAdClicked,
  onClosed,
  onRewarded
}

typedef void RewardedVideoAdListener(RewardedVideoAdEvent event,
    {int errorCode, RewardedItem item});

/// Acquire rewarded information. See for [details](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#acquire-rewarded-information).
class RewardedItem {
  int currencyAmount;
  String currencyName;
}
