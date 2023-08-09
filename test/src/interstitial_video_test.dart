import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nend_plugin/src/interstitial_video.dart';
import 'package:nend_plugin/src/video.dart';
import 'package:nend_plugin/src/nend_plugin.dart';

import 'interstitial_video_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MethodChannel>()])
void main() {
  final dummySpotId = 0;
  final dummyApiKey = 'dummyApiKey';
  final methodChannel = MockMethodChannel();
  final interstitialAd = InterstitialVideoAd.create(
      spotId: dummySpotId, apiKey: dummyApiKey, methodChannel: methodChannel);

  group(('VideoAd class test'), () {
    test('isReady ad method test', () async {
      verifyNever(interstitialAd.isReady());
      interstitialAd.isReady().then((value) => expect(value, isFalse));

      verify(NendPlugin.invokeMethod<bool>(
        channel: methodChannel,
        method: 'isReady',
      )).called(1);
    });

    test('init ad method test', () async {
      verify(NendPlugin.invokeMethod(
        channel: methodChannel,
        method: 'initAd',
        argument: interstitialAd.adUnit(dummySpotId, dummyApiKey),
      )).called(1);
    });

    test('load ad method test', () async {
      verifyNever(interstitialAd.loadAd());
      interstitialAd.loadAd();

      verify(NendPlugin.invokeMethod(
        channel: methodChannel,
        method: NendPlugin.method_name_load_ad,
      )).called(1);
    });

    test('show ad method test', () async {
      verifyNever(interstitialAd.showAd());
      interstitialAd.showAd();

      verify(NendPlugin.invokeMethod(
        channel: methodChannel,
        method: NendPlugin.method_name_show_ad,
      )).called(1);
    });

    test('set mediationName method test', () async {
      interstitialAd.mediationName = 'dummyMediationName';

      verify(NendPlugin.invokeMethod(
        channel: methodChannel,
        method: 'mediationName',
        argument: {'mediationName': 'dummyMediationName'},
      )).called(1);
    });

    test('detectVideoType method test', () {
      Map<String, String> typeNormal = {'type': 'normal'};
      Map<String, String> typePlayable = {'type': 'playable'};
      Map<String, String> typeUnknown = {'type': 'unknown'};

      interstitialAd.detectVideoType(typeNormal);
      expect(interstitialAd.videoType, VideoType.normal);

      interstitialAd.detectVideoType(typePlayable);
      expect(interstitialAd.videoType, VideoType.playable);

      interstitialAd.detectVideoType(typeUnknown);
      expect(interstitialAd.videoType, VideoType.unknown);
    });
  });

  group('InterstitialVideoAd class test', () {
    test('release ad method test', () async {
      verifyNever(interstitialAd.releaseAd());
      interstitialAd.releaseAd();

      verify(NendPlugin.invokeMethod(
        channel: methodChannel,
        method: NendPlugin.method_name_release_ad,
      )).called(1);
    });

    test('addFallbackFullboard ad method test', () async {
      verifyNever(interstitialAd.addFallbackFullboard(
          spotId: dummySpotId, apiKey: dummyApiKey));
      interstitialAd.addFallbackFullboard(
          spotId: dummySpotId, apiKey: dummyApiKey);

      verify(NendPlugin.invokeMethod(
          channel: methodChannel,
          method: 'addFallbackFullboard',
          argument: {
            NendPlugin.key_spot_id: dummySpotId,
            NendPlugin.key_api_key: dummyApiKey
          })).called(1);
    });

    test('muteStartPlaying ad method test', () async {
      interstitialAd.muteStartPlaying = false;

      verify(NendPlugin.invokeMethod(
        channel: methodChannel,
        method: 'muteStartPlaying',
        argument: {'muteStartPlaying': false},
      )).called(1);
    });
  });
}
