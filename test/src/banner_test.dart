import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nend_plugin/src/banner.dart';
import 'package:nend_plugin/src/nend_plugin.dart';

import 'banner_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MethodChannel>()])
void main() {
  final methodChannel = MockMethodChannel();

  group("BannerSize class test", () {
    test("size of 320x50", () {
      var banner = BannerSize(width: 320, height: 50);
      expect(banner, BannerSize.type320x50);
    });

    test("size of 320x100", () {
      var banner = BannerSize(width: 320, height: 100);
      expect(banner, BannerSize.type320x100);
    });

    test("size of 300x100", () {
      var banner = BannerSize(width: 300, height: 100);
      expect(banner, BannerSize.type300x100);
    });

    test("size of 300x250", () {
      var banner = BannerSize(width: 300, height: 250);
      expect(banner, BannerSize.type300x250);
    });

    test("size of 728x90", () {
      var banner = BannerSize(width: 728, height: 90);
      expect(banner, BannerSize.type728x90);
    });
  });

  group("BannerAdController class test", () {
    var adController =
        BannerAdController(methodChannel: methodChannel, adjustSize: false);

    test("called load ad method", () async {
      final dummySpotId = 0;
      final dummyApiKey = "dummy";

      verifyNever(adController.load(spotId: dummySpotId, apiKey: dummyApiKey));
      adController.load(spotId: dummySpotId, apiKey: dummyApiKey);
      verify(NendPlugin.invokeMethod(
          channel: methodChannel,
          method: NendPlugin.method_name_load_ad,
          argument: {
            'adjustSize': false,
            NendPlugin.key_ad_unit: {
              NendPlugin.key_spot_id: dummySpotId,
              NendPlugin.key_api_key: dummyApiKey
            }
          })).called(1);
    });

    test("called show ad method", () async {
      verifyNever(adController.show());
      adController.show();
      verify(NendPlugin.invokeMethod(
              channel: methodChannel, method: NendPlugin.method_name_show_ad))
          .called(1);
    });

    test("called hide ad method", () async {
      verifyNever(adController.hide());
      adController.hide();
      verify(NendPlugin.invokeMethod(
              channel: methodChannel, method: NendPlugin.method_name_hide_ad))
          .called(1);
    });

    test("called resume ad method", () async {
      verifyNever(adController.resume());
      adController.resume();
      verify(NendPlugin.invokeMethod(
              channel: methodChannel, method: NendPlugin.method_name_resume_ad))
          .called(1);
    });

    test("called pause ad method", () async {
      verifyNever(adController.pause());
      adController.pause();
      verify(NendPlugin.invokeMethod(
              channel: methodChannel, method: NendPlugin.method_name_pause_ad))
          .called(1);
    });

    test("called release ad method", () async {
      adController.dispose();
      verify(NendPlugin.invokeMethod(
              channel: methodChannel,
              method: NendPlugin.method_name_release_ad))
          .called(1);
    });
  });
}
