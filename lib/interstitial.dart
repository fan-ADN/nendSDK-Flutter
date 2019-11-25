import 'package:flutter/services.dart';
import 'package:nend_plugin/nend_plugin.dart';

/// See for [details](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-interstitial-ads#interstitial-ad-implementation-procedures).
class InterstitialAd {
  static const String tag = 'NendAdInterstitial';
  static const int defaultSpotId = -1;
  static InterstitialAd _shared;

  factory InterstitialAd() {
    if (_shared == null) {
      _shared = new InterstitialAd._internal();
      NendPlugin.invoke(_shared._mappingId, tag, NendPlugin.method_name_init);
    }
    return _shared;
  }
  InterstitialAd._internal();

  String get _mappingId => this.hashCode.toString();

  /// Loading ad. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-interstitial-ads#loading-ad).
  void load(int spotId, String apiKey) {
    NendPlugin.invoke(_mappingId, tag, NendPlugin.method_name_load_ad,
        argument: {
          NendPlugin.key_ad_unit: {
            NendPlugin.key_spot_id: spotId,
            NendPlugin.key_api_key: apiKey
          }
        });
  }

  /// Displaying ad. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-interstitial-ads#displaying-ad).
  void show([int spotId = defaultSpotId]) {
    NendPlugin.invoke(_mappingId, tag, NendPlugin.method_name_show_ad,
        argument: {NendPlugin.key_spot_id: spotId});
  }

  /// Dismiss ad. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-interstitial-ads#dismiss-ad).
  void dismiss() {
    NendPlugin.invoke(_mappingId, tag, NendPlugin.method_name_dismiss_ad);
  }

  /// Ad Auto-reloading. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-interstitial-ads#ad-auto-reloading).
  set enableAutoReload(bool isAutoReloadEnabled) {
    NendPlugin.invoke(_mappingId, tag, '.isEnableAutoReload',
        argument: {'enableAutoReload': isAutoReloadEnabled});
  }

  InterstitialAdListener _listener;
  InterstitialAdListener get listener => _listener;
  /// Register the listener to receive the ad event. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-interstitial-ads#event-listener).
  set listener(InterstitialAdListener value) {
    _listener = value;
    NendPlugin.addListener(_mappingId, this);
  }

  dynamic eventFrom(String type) {
    type = type.split(".").last;
    type = 'InterstitialAdEvent.$type';
    return InterstitialAdEvent.values
        .firstWhere((event) => event.toString() == type, orElse: () => null);
  }

  void notify(MethodCall call) {
    InterstitialAdEvent event = eventFrom(call.method);
    Map<String, dynamic> map = call.arguments;
    var spotId = int.parse(map[NendPlugin.key_spot_id]);
    if (event == InterstitialAdEvent.onFailedToLoad) {
      int code = int.parse(map[NendPlugin.key_error_code].toString());
      listener(event, spotId, errorCode: code);
    } else {
      listener(event, spotId);
    }
  }
}

/// Receive the ad event. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-interstitial-ads#event-listener).
enum InterstitialAdEvent {
  onLoaded,
  onFailedToLoad,
  onShown,
  onInformationClicked,
  onAdClicked,
  onClosed,
  onFailedToShow
}

typedef void InterstitialAdListener(InterstitialAdEvent event, int spotId,
    {int errorCode});
