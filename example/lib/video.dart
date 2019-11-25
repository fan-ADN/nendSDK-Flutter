import 'package:flutter/material.dart';
import 'package:nend_plugin/interstitial_video.dart';
import 'package:nend_plugin/rewarded_video.dart';
import 'package:nend_plugin/user_feature.dart';
import 'main.dart';
import 'dart:io' show Platform;

const String _tag = 'Video';

class Video extends StatefulWidget {
  @override
  _VideoState createState() => new _VideoState();
}

class _VideoState extends State<Video> {
  String _interstitialState = _tag;
  String _rewardedState = _tag;
  String _fallbackState = _tag;
  InterstitialVideo _interstitial;
  InterstitialVideo _fallback;
  RewardedVideo _reward;

  @override
  void initState() {
    super.initState();
    _initializeInterstitial();
    _initializeReward();
  }

  int get interstitialSpotId => (Platform.isAndroid ? 802559 : 802557);
  String get interstitialApiKey => (Platform.isAndroid
      ? "e9527a2ac8d1f39a667dfe0f7c169513b090ad44"
      : "b6a97b05dd088b67f68fe6f155fb3091f302b48b");
  int get rewardedSpotId => (Platform.isAndroid ? 802558 : 802555);
  String get rewardedApiKey => (Platform.isAndroid
      ? "a6eb8828d64c70630fd6737bd266756c5c7d48aa"
      : "ca80ed7018734d16787dbda24c9edd26c84c15b8");
  int get fallbackSpotId => (Platform.isAndroid ? 485520 : 485504);
  String get fallbackApiKey => (Platform.isAndroid
      ? "a88c0bcaa2646c4ef8b2b656fd38d6785762f2ff"
      : "30fda4b3386e793a14b27bedb4dcd29f03d638e5");

  void _initializeInterstitial() {
    _interstitial = InterstitialVideo(interstitialSpotId, interstitialApiKey);
    _interstitial.listener = (InterstitialVideoAdEvent event, {int errorCode}) {
      setState(() {
        switch (event) {
          case InterstitialVideoAdEvent.onFailedToLoad:
            _interstitialState = event.toString() + ' errorCode: $errorCode';
            break;
          case InterstitialVideoAdEvent.onFailedToPlay:
          case InterstitialVideoAdEvent.onShown:
          case InterstitialVideoAdEvent.onLoaded:
            _interstitialState = event.toString();
            break;
          default:
            print(event.toString());
            break;
        }
      });
    };
    _interstitial.mediationName = 'mediationName';
    _interstitial.userId = 'userId';

    _interstitial.userFeature = UserFeature()
      ..gender = Gender.female
      ..age = 39
      ..setBirthday(1913, 2, 28)
      ..customBooleanParams['booleanParamKey'] = true
      ..customStringParams['stringParamKey'] = 'Hoge Fuga'
      ..customIntegerParams['integerParamKey'] = 3
      ..customDoubleParams['doubleParamKey'] = 20.43;
    _interstitial.locationEnabled = false;
    _interstitial.muteStartPlaying = false;
  }

  void _initializeFallback() {
    _fallback = InterstitialVideo(1234, 'fallback');
    _fallback.addFallbackFullboard(fallbackSpotId, fallbackApiKey);
    _fallback.listener = (InterstitialVideoAdEvent event, {int errorCode}) {
      setState(() {
        switch (event) {
          case InterstitialVideoAdEvent.onFailedToLoad:
            _fallbackState =
                'Fallback ' + event.toString() + ' errorCode: $errorCode';
            break;
          case InterstitialVideoAdEvent.onFailedToPlay:
          case InterstitialVideoAdEvent.onShown:
          case InterstitialVideoAdEvent.onLoaded:
            _fallbackState = 'Fallback ' + event.toString();
            break;
          default:
            print('Fallback ' + event.toString());
            break;
        }
      });
    };
  }

  void _initializeReward() {
    _reward = RewardedVideo(rewardedSpotId, rewardedApiKey);
    _reward.listener =
        (RewardedVideoAdEvent event, {int errorCode, RewardedItem item}) {
      setState(() {
        switch (event) {
          case RewardedVideoAdEvent.onRewarded:
            String name = item.currencyName;
            int amount = item.currencyAmount;
            _rewardedState = event.toString() +
                ' currencyName: $name, currencyAmount: $amount';
            break;
          case RewardedVideoAdEvent.onFailedToLoad:
            _rewardedState = event.toString() + ' errorCode: $errorCode';
            break;
          case RewardedVideoAdEvent.onFailedToPlay:
          case RewardedVideoAdEvent.onLoaded:
          case RewardedVideoAdEvent.onShown:
            _rewardedState = event.toString();
            break;
          default:
            print(event.toString());
            break;
        }
      });
    };
    _reward.locationEnabled = true;
  }

  void _showLoadedAd() {
    _reward.isReady.then((ready) {
      if (ready) {
        _reward.showAd();
      } else if (_interstitial != null) {
        _interstitial.isReady.then((readyInterstitial) {
          if (readyInterstitial) {
            _interstitial.showAd();
          }
        });
      } else if (_fallback != null) {
        _fallback.isReady.then((readyFallback) {
          if (readyFallback) {
            _fallback.showAd();
          }
        });
      }
    });
  }

  void _loadInterstitial() {
    _releaseFallback();
    if (_interstitial == null) {
      _initializeInterstitial();
    }
    setState(() {
      _interstitialState = 'loading';
    });
    _interstitial.loadAd();
  }

  void _releaseInterstitial() {
    if (_interstitial != null) {
      _interstitial.releaseAd();
      setState(() {
        _interstitial = null;
        _interstitialState = _tag;
      });
    }
  }

  void _loadReward() {
    setState(() {
      _rewardedState = 'loading';
    });
    _reward.loadAd();
  }

  void _releaseReward() {
    _reward.releaseAd();
    setState(() {
      _rewardedState = _tag;
    });
  }

  void _loadFallback() {
    _releaseInterstitial();
    if (_fallback == null) {
      _initializeFallback();
    }
    setState(() {
      _fallbackState = 'loading';
    });
    _fallback.loadAd();
  }

  void _releaseFallback() {
    if (_fallback != null) {
      _fallback.releaseAd();
      setState(() {
        _fallback = null;
        _fallbackState = _tag;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Video example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new StateDisplay(title: 'Interstitial', state: _interstitialState),
            new StateDisplay(title: 'Fallback', state: _fallbackState),
            new StateDisplay(title: 'Reward', state: _rewardedState),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new VideoAction(
                        onPressed: _loadInterstitial,
                        typeDescriptionStr: 'Load Interstitial'),
                    new VideoAction(
                        onPressed: _releaseInterstitial,
                        typeDescriptionStr: 'Release Interstitial'),
                    new VideoAction(
                        onPressed: _loadFallback,
                        typeDescriptionStr: 'Load Fallback'),
                    new VideoAction(
                        onPressed: _releaseFallback,
                        typeDescriptionStr: 'Release Fallback'),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new VideoAction(
                        onPressed: _loadReward,
                        typeDescriptionStr: 'Load Reward'),
                    new VideoAction(
                        onPressed: _releaseReward,
                        typeDescriptionStr: 'Release Reward'),
                  ]),
            ])
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key('Show Ad'),
        onPressed: _showLoadedAd,
        tooltip: 'Show Ad',
        child: Icon(Icons.play_circle_outline),
      ),
    );
  }
}

class VideoAction extends StatelessWidget {
  VideoAction({this.onPressed, this.typeDescriptionStr});
  final VoidCallback onPressed;
  final String typeDescriptionStr;
  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      key: Key(typeDescriptionStr),
      onPressed: onPressed,
      child: new Text(typeDescriptionStr),
    );
  }
}
