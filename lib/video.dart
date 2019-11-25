import 'dart:async';

import 'package:flutter/services.dart';
import 'nend_plugin.dart';
import 'user_feature.dart';

/// An abstract class of video ads.
abstract class Video {
  String _targetClassName;
  static MethodChannel _channel = NendPlugin.channel;
  Map simpleMappingArgument;

  Video(String name, int spotId, String apiKey) {
    _targetClassName = name;
    invoke(NendPlugin.method_name_init, argument: adUnit(spotId, apiKey));
    simpleMappingArgument = {NendPlugin.key_mapping_id: _targetClassName};
  }

  Map mappingId({Map argument}) {
    if (argument == null) {
      return simpleMappingArgument;
    } else {
      argument[NendPlugin.key_mapping_id] = _targetClassName;
    }
    return argument;
  }

  dynamic adUnit(int spotId, String apiKey) {
    return {
      NendPlugin.key_mapping_id: _targetClassName,
      NendPlugin.key_ad_unit: {
        NendPlugin.key_spot_id: spotId,
        NendPlugin.key_api_key: apiKey
      }
    };
  }

  Future<bool> get isReady async {
    return await _channel.invokeMethod(
        _targetClassName + '.isReady', mappingId());
  }

  /// [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#load-video-ad) that load interstitial video ad.
  /// [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#load-video-ad-1) that load rewarded video ad.
  void loadAd() {
    invoke(NendPlugin.method_name_load_ad);
  }

  /// [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#show-video-ad) that show interstitial video ad.
  /// [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#show-video-ad-1) that show rewarded video ad.
  void showAd() {
    invoke(NendPlugin.method_name_show_ad);
  }

  /// [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#release-video-ad) that release interstitial video ad.
  /// [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#release-video-ad-1) that release rewarded video ad.
  void releaseAd() async {
    await invoke(NendPlugin.method_name_release_ad);
    await invoke(NendPlugin.method_name_dispose);
  }

  set mediationName(String value) {
    invoke('.mediationName', argument: {'mediationName': value});
  }

  /// Set up user name. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#set-up-user-name).
  set userId(String value) {
    invoke('.userId', argument: {'userId': value});
  }

  /// Set up features of user. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#set-up-features-of-user).
  set userFeature(UserFeature feature) {
    invoke('.userFeature', argument: {
      'userFeature': {
        'gender': feature.gender.index,
        'age': feature.age,
        'birthday': feature.birthday,
        'customStringParams': feature.customStringParams,
        'customIntegerParams': feature.customIntegerParams,
        'customDoubleParams': feature.customDoubleParams,
        'customBooleanParams': feature.customBooleanParams
      }
    });
  }

  /// Set up state of using location data. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#set-up-state-of-using-location-data).
  set locationEnabled(bool enabledLocation) {
    invoke('.locationEnabled', argument: {'locationEnabled': enabledLocation});
  }

  Future<void> invoke(String method, {Map argument}) async {
    argument = mappingId(argument: argument);
    await _channel.invokeMethod(_targetClassName + method, argument);
  }

  dynamic eventFrom(String method);
  void notify(MethodCall call);
}
