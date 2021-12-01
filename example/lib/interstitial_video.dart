import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:nend_plugin/nend_plugin.dart';

class InterstitialVideoSample extends StatefulWidget {
  const InterstitialVideoSample();

  @override
  _InterstitialVideoSampleState createState() =>
      _InterstitialVideoSampleState();
}

class _InterstitialVideoSampleState extends State<InterstitialVideoSample> {
  InterstitialVideoAd? interstitialVideoAd;
  bool isReady = false;

  int get interstitialSpotId => Platform.isAndroid ? 802559 : 802557;
  String get interstitialApiKey => Platform.isAndroid
      ? 'e9527a2ac8d1f39a667dfe0f7c169513b090ad44'
      : 'b6a97b05dd088b67f68fe6f155fb3091f302b48b';
  int get fallbackSpotId => Platform.isAndroid ? 485520 : 485504;
  String get fallbackApiKey => Platform.isAndroid
      ? 'a88c0bcaa2646c4ef8b2b656fd38d6785762f2ff'
      : '30fda4b3386e793a14b27bedb4dcd29f03d638e5';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    final ad = this.interstitialVideoAd;
    if (ad == null) return;
    ad.releaseAd();
    interstitialVideoAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InterstitialVideo Sample'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            TextButton(
              onPressed: () async {
                var ad = this.interstitialVideoAd;
                if (ad == null) {
                  initInterstitialVideo();
                }
                ad = this.interstitialVideoAd;
                if (ad == null) return;
                await ad.loadAd();
              },
              child: Text('Load InterstitialVideo'),
            ),
            TextButton(
              onPressed: () async => await loadFallbackFullboard(),
              child: Text('Load Fallback Fullboard'),
            ),
            TextButton(
              onPressed: isReady
                  ? () async {
                      final ad = this.interstitialVideoAd;
                      if (ad == null) return;
                      final isReady = await ad.isReady();
                      if (isReady) {
                        await ad.showAd();
                      }
                    }
                  : null,
              child: Text('Show InterstitialVideo'),
            ),
            TextButton(
              onPressed: () {
                final ad = this.interstitialVideoAd;
                if (ad == null) return;
                ad.releaseAd();
                interstitialVideoAd = null;
              },
              child: Text('Release InterstitialVideo'),
            ),
          ],
        ),
      ),
    );
  }

  void initInterstitialVideo() {
    interstitialVideoAd = InterstitialVideoAd(
      spotId: interstitialSpotId,
      apiKey: interstitialApiKey,
    );

    final ad = interstitialVideoAd;
    if (ad == null) return;
    ad.setEventListener(_interstitialAdListener());

    ad.mediationName = 'mediationName';
    ad.userId = 'userId';
    ad.userFeature = UserFeature()
      ..gender = Gender.female
      ..age = 39
      ..setBirthday(1913, 2, 28)
      ..customBooleanParams['booleanParamKey'] = true
      ..customStringParams['stringParamKey'] = 'Hoge Fuga'
      ..customIntegerParams['integerParamKey'] = 3
      ..customDoubleParams['doubleParamKey'] = 20.43;
  }

  Future<void> loadFallbackFullboard() async {
    interstitialVideoAd = InterstitialVideoAd(spotId: 123, apiKey: 'apikey');
    final ad = interstitialVideoAd;
    if (ad == null) return;
    ad.setEventListener(_interstitialAdListener());
    ad.addFallbackFullboard(
      spotId: fallbackSpotId,
      apiKey: fallbackApiKey,
    );

    await ad.loadAd();
  }

  InterstitialVideoAdListener _interstitialAdListener() {
    return InterstitialVideoAdListener(
      onLoaded: () {
        print('onLoaded');
        setState(() {
          isReady = true;
        });
      },
      onFailedToLoad: () {
        print('onFailedToLoad');
        setState(() {
          isReady = false;
        });
      },
      onFailedToPlay: () {
        print('onFailedToPlay');
        setState(() {
          isReady = false;
        });
      },
      onShown: () {
        print('onShown');
      },
      onClosed: () {
        print('onClosed');
        setState(() {
          isReady = false;
        });
      },
      onStarted: () {
        print('onStarted');
      },
      onStopped: () {
        print('onStopped');
      },
      onCompleted: () {
        print('onCompleted');
      },
      onAdClicked: () {
        print('onAdClicked');
      },
      onInformationClicked: () {
        print('onInformationClicked');
      },
    );
  }
}