import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:nend_plugin/nend_plugin.dart';

void main() => runApp(InterstitialVideoSample());

class InterstitialVideoSample extends StatefulWidget {
  const InterstitialVideoSample();

  @override
  _InterstitialVideoSampleState createState() =>
      _InterstitialVideoSampleState();
}

class _InterstitialVideoSampleState extends State<InterstitialVideoSample> {
  InterstitialVideoAd? interstitialVideoAd;
  bool isReady = false;

  int loadCnt = 0;
  int showCnt = 0;
  int failedToLoadCnt = 0;
  int failedToPlayCnt = 0;
  int infoClickCnt = 0;
  int clickCnt = 0;
  int closeCnt = 0;
  int startCnt = 0;
  int stopCnt = 0;
  int completeCnt = 0;

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
    return MaterialApp(
        home: Scaffold(
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
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Interstitial Video Ad Listener Counter",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("onLoaded: $loadCnt"),
                Text("onShown: $showCnt"),
                Text("onFailedToLoad: $failedToLoadCnt"),
                Text("onFailedToPlay: $failedToPlayCnt"),
                Text("onInformationClicked: $infoClickCnt"),
                Text("onAdClicked: $clickCnt"),
                Text("onClosed: $closeCnt"),
                Text("onStarted: $startCnt"),
                Text("onStopped: $stopCnt"),
                Text("onCompleted: $completeCnt"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ));
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
          loadCnt++;
        });
      },
      onFailedToLoad: () {
        print('onFailedToLoad');
        setState(() {
          isReady = false;
          failedToLoadCnt++;
        });
      },
      onFailedToPlay: () {
        print('onFailedToPlay');
        setState(() {
          isReady = false;
          failedToPlayCnt++;
        });
      },
      onShown: () {
        print('onShown');
        showCnt++;
      },
      onClosed: () {
        print('onClosed');
        setState(() {
          isReady = false;
          closeCnt++;
        });
      },
      onStarted: () {
        print('onStarted');
        startCnt++;
      },
      onStopped: () {
        print('onStopped');
        stopCnt++;
      },
      onCompleted: () {
        print('onCompleted');
        completeCnt++;
      },
      onAdClicked: () {
        print('onAdClicked');
        clickCnt++;
      },
      onInformationClicked: () {
        print('onInformationClicked');
        infoClickCnt++;
      },
    );
  }
}
