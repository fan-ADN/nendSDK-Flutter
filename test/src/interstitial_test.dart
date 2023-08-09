import 'package:flutter/services.dart';
import 'package:mockito/annotations.dart';
import 'package:nend_plugin/nend_plugin.dart';
import 'package:nend_plugin/src/interstitial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nend_plugin/src/nend_plugin.dart';

@GenerateNiceMocks([MockSpec<MethodChannel>()])
import 'interstitial_test.mocks.dart';

void main() {
  final methodChannel = MockMethodChannel();
  final interstitialAd = InterstitialAd.create(methodChannel: methodChannel);

  group("InterstitialAd test", () {
    test("load ad method", () {
      final dummySpotId = 0;
      final dummyApiKey = "dummyApiKey";

      verifyNever(
          interstitialAd.loadAd(spotId: dummySpotId, apiKey: dummyApiKey));
      interstitialAd.loadAd(spotId: dummySpotId, apiKey: dummyApiKey);
      verify(NendPlugin.invokeMethod(
          channel: methodChannel,
          method: NendPlugin.method_name_load_ad,
          argument: {
            NendPlugin.key_spot_id: dummySpotId,
            NendPlugin.key_api_key: dummyApiKey,
          })).called(1);
    });

    test("show ad method", () {
      final dummySpotId = 0;

      verifyNever(interstitialAd.showAd(spotId: dummySpotId));
      interstitialAd.showAd(spotId: dummySpotId);
      verify(NendPlugin.invokeMethod(
          channel: methodChannel,
          method: NendPlugin.method_name_show_ad,
          argument: {NendPlugin.key_spot_id: dummySpotId})).called(1);
    });

    test("dismiss ad method", () {
      verifyNever(interstitialAd.dismissAd());
      interstitialAd.dismissAd();
      verify(NendPlugin.invokeMethod(
              channel: methodChannel,
              method: NendPlugin.method_name_dismiss_ad))
          .called(1);
    });

    test("enable auto reload ad method", () {
      final isEnabled = false;
      verifyNever(interstitialAd.enableAutoReload(isEnabled: isEnabled));
      interstitialAd.enableAutoReload(isEnabled: isEnabled);
      verify(NendPlugin.invokeMethod(
          channel: methodChannel,
          method: NendPlugin.method_name_enable_auto_reload,
          argument: {'enableAutoReload': isEnabled})).called(1);
    });
  });
}
