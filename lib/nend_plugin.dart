import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nend_plugin/interstitial.dart';
import 'banner.dart';
import 'native.dart';
import 'interstitial_video.dart';
import 'rewarded_video.dart';

class NendPlugin {
  static const key_mapping_id = 'mappingId';
  static const key_error_code = 'errorCode';

  static const key_ad_unit = 'adUnit';
  static const key_spot_id = 'spotId';
  static const key_api_key = 'apiKey';

  static const method_name_init = '.init';
  static const method_name_dispose = '.dispose';
  static const method_name_load_ad = '.loadAd';
  static const method_name_release_ad = '.releaseAd';
  static const method_name_show_ad = '.showAd';
  static const method_name_hide_ad = '.hideAd';
  static const method_name_dismiss_ad = '.dismissAd';

  static const MethodChannel channel =
      const MethodChannel('nend_plugin', JSONMethodCodec());
  static Map _listenerMap = Map<String, Object>();

  static Future<void> _handle(MethodCall methodCall) async {
    String target = methodCall.method.split(".")[0];
    String key = _getIdFrom(methodCall.arguments);
    switch (target) {
      case BannerAd.tag:
      case NativeAdLoader.tag:
      case InterstitialVideo.tag:
      case RewardedVideo.tag:
      case InterstitialAd.tag:
        _listenerMap[key].notify(methodCall);
        break;
      default:
        break;
    }
  }

  static Future<void> invoke(String id, String targetClassName, String method,
      {Map argument}) async {
    argument = mappingId(id, argument: argument);
    await channel.invokeMethod(targetClassName + method, argument);
  }

  static Map mappingId(String mappingId, {Map argument}) {
    if (argument == null) {
      return {NendPlugin.key_mapping_id: mappingId};
    } else {
      argument[NendPlugin.key_mapping_id] = mappingId;
    }
    return argument;
  }

  static String _getIdFrom(dynamic arguments) {
    Map<String, dynamic> map = arguments;
    return map[key_mapping_id];
  }

  static void addListener(String key, Object obj) {
    if (_listenerMap.isEmpty) {
      channel.setMethodCallHandler(_handle);
    }
    _listenerMap[key] = obj;
  }
}
