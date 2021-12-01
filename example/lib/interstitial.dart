import 'dart:io';

import 'package:flutter/material.dart';

import 'package:nend_plugin/nend_plugin.dart';

class InterstitialSample extends StatefulWidget {
  @override
  _InterstitialSampleState createState() => _InterstitialSampleState();
}

class _InterstitialSampleState extends State<InterstitialSample> {
  late InterstitialAd _interstitial;

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
    return Scaffold(
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
                // Need set false for enableAutoReload when before call dismissAd method.
                // If didn't set false, it will crash your app.
                await _interstitial.enableAutoReload(isEnabled: false);
                await Future.delayed(Duration(seconds: 5));
                _interstitial.dismissAd();
                await _interstitial.enableAutoReload(isEnabled: needAutoReload);
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
          ],
        ),
      ),
    );
  }

  InterstitialAdListener _listener() {
    return InterstitialAdListener(
      onShown: (Object? arg) {
        print((arg as Map)['result']);
      },
      onFailedToShow: (Object? arg) {
        print((arg as Map)['result']);
      },
      onLoaded: (Object? arg) {
        print((arg as Map)['result']);
      },
      onFailedToLoad: (Object? arg) {
        print((arg as Map)['result']);
      },
      onAdClicked: () => print('onAdClicked'),
      onInformationClicked: () => print('onInformationClicked'),
      onClosed: () => print('onClosed'),
    );
  }
}
