import 'dart:io';

import 'package:flutter/material.dart';

import 'package:nend_plugin/nend_plugin.dart';

void main() => runApp(InterstitialSample());

class InterstitialSample extends StatefulWidget {
  @override
  _InterstitialSampleState createState() => _InterstitialSampleState();
}

class _InterstitialSampleState extends State<InterstitialSample> {
  late InterstitialAd _interstitial;

  int loadCnt = 0;
  int showCnt = 0;
  int failedToLoadCnt = 0;
  int failedToShowCnt = 0;
  int infoClickCnt = 0;
  int clickCnt = 0;
  int closeCnt = 0;

  int get spotId => Platform.isAndroid ? 213206 : 213208;

  String get apiKey => Platform.isAndroid
      ? '8c278673ac6f676dae60a1f56d16dad122e23516'
      : '308c2499c75c4a192f03c02b2fcebd16dcb45cc9';

  int get spotId2 => Platform.isAndroid ? 213206 : 213208;

  String get apiKey2 => Platform.isAndroid
      ? '8c278673ac6f676dae60a1f56d16dad122e23516'
      : '308c2499c75c4a192f03c02b2fcebd16dcb45cc9';

  bool needAutoReload = true;

  @override
  void initState() {
    super.initState();
    _interstitial = InterstitialAd();
    _interstitial.setEventListener(_listener());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Interstitial example'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            TextButton(
              onPressed: () =>
                  _interstitial.loadAd(spotId: spotId, apiKey: apiKey),
              child: Text('Load: type 1'),
            ),
            TextButton(
              onPressed: () => _interstitial.showAd(spotId: spotId),
              child: Text('Show type 1'),
            ),
            TextButton(
              onPressed: () =>
                  _interstitial.loadAd(spotId: spotId2, apiKey: apiKey2),
              child: Text('Load: type 2'),
            ),
            TextButton(
              onPressed: () => _interstitial.showAd(spotId: spotId2),
              child: Text('Show type 2'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  needAutoReload = !needAutoReload;
                  _interstitial.enableAutoReload(isEnabled: needAutoReload);
                });
              },
              child: Text(
                needAutoReload ? 'Disable Auto Reload' : 'Enable Auto Reload',
              ),
            ),
            TextButton(
              onPressed: () async {
                await Future.delayed(Duration(seconds: 5));
                _interstitial.dismissAd();
              },
              child: Text('Test dismissAd'),
            ),
            Text(
              'How to test for dismissAd method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text('Step 1: Tap to Load button'),
            Text('Step 2: Tap to Test dismissAd button'),
            Text('Step 3: Tap to Show button'),
            Text('Step 4: Wait for a few seconds'),
            Text('Step 5: Will be closed interstitial Ads to automatically'),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Interstitial Ad Listener Counter",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("onLoaded: $loadCnt"),
                Text("onShown: $showCnt"),
                Text("onFailedToLoad: $failedToLoadCnt"),
                Text("onFailedToShow: $failedToShowCnt"),
                Text("onInformationClicked:$infoClickCnt"),
                Text("onAdClicked: $clickCnt"),
                Text("onClosed: $closeCnt"),
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

  InterstitialAdListener _listener() {
    return InterstitialAdListener(
      onShown: (Object? arg) {
        print((arg as Map)['result']);
        setState(() {
          showCnt++;
        });
      },
      onFailedToShow: (Object? arg) {
        print((arg as Map)['result']);
        setState(() {
          failedToShowCnt++;
        });
      },
      onLoaded: (Object? arg) {
        print((arg as Map)['result']);
        setState(() {
          loadCnt++;
        });
      },
      onFailedToLoad: (Object? arg) {
        print((arg as Map)['result']);
        setState(() {
          failedToLoadCnt++;
        });
      },
      onAdClicked: () => {
        print('onAdClicked'),
        setState(() {
          clickCnt++;
        })
      },
      onInformationClicked: () => {
        print('onInformationClicked'),
        setState(() {
          infoClickCnt++;
        })
      },
      onClosed: () => {
        print('onClosed'),
        setState(() {
          closeCnt++;
        })
      },
    );
  }
}
