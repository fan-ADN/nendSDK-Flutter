import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:nend_plugin/nend_plugin.dart';

void main() => runApp(RewardedVideoSample());

class RewardedVideoSample extends StatefulWidget {
  const RewardedVideoSample();

  @override
  _RewardedVideoSampleState createState() => _RewardedVideoSampleState();
}

class _RewardedVideoSampleState extends State<RewardedVideoSample> {
  late RewardedVideoAd rewardedVideoAd;
  bool isReady = false;
  Map? reward;

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
  int rewardedCnt = 0;

  int get rewardedSpotId => Platform.isAndroid ? 802558 : 802555;

  String get rewardedApiKey => Platform.isAndroid
      ? 'a6eb8828d64c70630fd6737bd266756c5c7d48aa'
      : 'ca80ed7018734d16787dbda24c9edd26c84c15b8';

  @override
  void initState() {
    super.initState();
    initRewardedVideoAd();
  }

  @override
  void dispose() {
    super.dispose();
    rewardedVideoAd.releaseAd();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('RewardedVideo Sample'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            TextButton(
              onPressed: () async => await rewardedVideoAd.loadAd(),
              child: Text('Load RewardedVideo'),
            ),
            TextButton(
              onPressed: isReady
                  ? () async {
                      final isReady = await rewardedVideoAd.isReady();
                      if (isReady) {
                        await rewardedVideoAd.showAd();
                      }
                    }
                  : null,
              child: Text('Show RewardedVideo'),
            ),
            SizedBox(
              height: 10,
            ),
            Text("[Reward]", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("name: ${reward?['name'] ?? '(^ ^)'}"),
            Text("amount: ${reward?['amount'] ?? '(^ ^)'}"),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Rewarded Video Ad Listener Counter",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("onRewarded: $rewardedCnt"),
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

  void initRewardedVideoAd() {
    rewardedVideoAd = RewardedVideoAd(
      spotId: rewardedSpotId,
      apiKey: rewardedApiKey,
    );

    rewardedVideoAd.setEventListener(_rewardedVideoAdListener());

    rewardedVideoAd.mediationName = 'mediationName';
  }

  RewardedVideoAdListener _rewardedVideoAdListener() {
    return RewardedVideoAdListener(
      onRewarded: (arg) {
        reward = (arg as Map)['reward'];
        setState(() {
          rewardedCnt++;
        });
      },
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
