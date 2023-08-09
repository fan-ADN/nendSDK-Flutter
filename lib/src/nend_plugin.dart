import 'dart:async';

import 'package:flutter/services.dart';

class NendPlugin {
  static const key_ad_unit = 'adUnit';
  static const key_spot_id = 'spotId';
  static const key_api_key = 'apiKey';

  static const method_name_init = 'init';
  static const method_name_dispose = 'dispose';
  static const method_name_load_ad = 'loadAd';
  static const method_name_release_ad = 'releaseAd';
  static const method_name_show_ad = 'showAd';
  static const method_name_hide_ad = 'hideAd';
  static const method_name_dismiss_ad = 'dismissAd';
  static const method_name_enable_auto_reload = 'enableAutoReload';
  static const method_name_resume_ad = 'resume';
  static const method_name_pause_ad = 'pause';

  static Future<T?> invokeMethod<T>({
    required MethodChannel channel,
    required String method,
    Map? argument,
  }) async {
    return await channel.invokeMethod(method, argument);
  }
}

typedef AdEventCallBack = void Function();
typedef AdEventCallBackUseArgument = void Function(Object arg);
