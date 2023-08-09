import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nend_plugin/nend_plugin.dart';
import 'package:nend_plugin/src/nend_plugin.dart';

import 'interstitial_video_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MethodChannel>()])
void main() {
  final dummySpotId = 0;
  final dummyApiKey = 'dummyApiKey';
  final methodChannel = MockMethodChannel();
  final rewardedAd = RewardedVideoAd.create(
      spotId: dummySpotId, apiKey: dummyApiKey, methodChannel: methodChannel);

  group('RewardedVideoAd class test', () {
    test('release ad method test', () async {
      verifyNever(rewardedAd.releaseAd());
      rewardedAd.releaseAd();

      verify(NendPlugin.invokeMethod(
        channel: methodChannel,
        method: NendPlugin.method_name_release_ad,
      )).called(1);
    });
  });
}
