import 'dart:async';

import 'package:flutter/services.dart';

import 'nend_plugin.dart';

/// An abstract class of VideoAd.
abstract class VideoAd {
  late String adType;
  late final channel = MethodChannel(
    'nend_plugin/$adType',
    JSONMethodCodec(),
  );
  VideoType videoType = VideoType.unknown;

  Map adUnit(int spotId, String apiKey) {
    return {
      NendPlugin.key_spot_id: spotId,
      NendPlugin.key_api_key: apiKey,
    };
  }

  /// Can confirm if the VideoAd can play the video.
  Future<bool> isReady() async {
    return await NendPlugin.invokeMethod<bool>(
          channel: channel,
          method: 'isReady',
        ) ??
        false;
  }

  // Init the VideoAd.
  Future<void> init({required int spotId, required String apiKey}) async {
    await NendPlugin.invokeMethod(
      channel: channel,
      method: 'initAd',
      argument: adUnit(spotId, apiKey),
    );
  }

  /// Load the VideoAd.
  Future<void> loadAd() async {
    await NendPlugin.invokeMethod(
      channel: channel,
      method: NendPlugin.method_name_load_ad,
    );
  }

  /// Show the VideoAd.
  Future<void> showAd() async {
    await NendPlugin.invokeMethod(
      channel: channel,
      method: NendPlugin.method_name_show_ad,
    );
  }

  /// Release the VideoAd.
  Future<void> releaseAd() async {
    await NendPlugin.invokeMethod(
      channel: channel,
      method: NendPlugin.method_name_release_ad,
    );
  }

  /// Can set the mediation name.
  set mediationName(String value) {
    NendPlugin.invokeMethod(
      channel: channel,
      method: 'mediationName',
      argument: {'mediationName': value},
    );
  }

  /// This method runs after the ad loads and then you can get the type of video by accessing [videoType].
  void detectVideoType(dynamic response) {
    final type = (response as Map)['type'];
    videoType = VideoType.values.firstWhere(
      (VideoType e) => e.enumToString == type,
      orElse: () => VideoType.unknown,
    );
    print(videoType.toString());
  }
}

enum VideoType {
  normal,
  playable,
  unknown,
}

extension VideoTypeExtension on VideoType {
  String get enumToString {
    return this.toString().split('.')[1];
  }
}
