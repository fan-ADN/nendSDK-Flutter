import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:nend_plugin/nend_plugin.dart';

class RewardedVideoSample extends StatefulWidget {
  const RewardedVideoSample();

  @override
  _RewardedVideoSampleState createState() => _RewardedVideoSampleState();
}

class _RewardedVideoSampleState extends State<RewardedVideoSample> {
  late RewardedVideoAd rewardedVideoAd;
  bool isReady = false;
  Map? reward;

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
    return Scaffold(
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
            Text(
              '''
                [Reward]\n
                name: ${reward?['name'] ?? '(^ ^)'}\n
                amount: ${reward?['amount'] ?? '(^ ^)'}
              ''',
            )
          ],
        ),
      ),
    );
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
      },
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
