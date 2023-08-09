# nend_plugin

## Supported Ad formats
- [Banner](#BannerAd)
- [Interstitial](#InterstitialAd)
- Video(also interactive and playable)
  - [Rewarded](#RewardedVideoAd)
  - [Interstitial](#InterstitialVideoAd)

## Install
Add this to your package's `pubspec.yaml` file and execute `flutter pub get`:
```Dart
dependencies:
  nend_plugin: ^2.0.1
```
## Preparation
Go to [nend admin page](https://www.nend.net/admin/login). Create ad space and obtain **apiKey**, **spotId**.
(Please check Management screen manual separately for details.)

## Verification
### About IDs
You can check ads displaying are correctly on your Android/iOS app using TEST ID, without your activated ad unit IDs.

- [Test ID list for iOS](https://github.com/fan-ADN/nendSDK-iOS/wiki/Verification)
- [Test ID list for Android](https://github.com/fan-ADN/nendSDK-Android/wiki/Verification)

You have to **replace the apiKey and spotID from TEST IDs to YOUR PRODUCTION IDs, before deploy** your application to App Store/Google Play.

The ads does not perform correctly if you deploy your app with TEST IDs.  
**We DO NOT take any responsibility if you have a mistake to your app about settings ad unit IDs.**

### If you want to check error case...
The simplest way to checking error case, you may try to load ad while device is offline.

## BannerAd
### Example
```Dart
...

late BannerAdController adController;

@override
Widget build(BuildContext context) {
  return Scaffold(
    child: BannerAd(
      bannerSize: BannerSize.type320x50,
      listener: _eventListener(),
      onCreated: (controller) {
        adController = controller;
        adController.load(spotId: spotId, apiKey: apiKey);
      },
    ),
  );
}

BannerAdListener _eventListener() {
  return BannerAdListener(
    onLoaded: () => print('onLoaded'),
    onReceiveAd: () => print('onReceived'),
    onFailedToLoad: () => print('onFailedToLoad'),
    onAdClicked: () => print('onAdClicked'),
    onInformationClicked: () => print('onInformationClicked'),
  );
}

```

The following banner sizes are available on nend.

```Dart
bannerSize: BannerSize.type320x50
```
|Argument|Size|
|:--:|:--:|
|type320x50|320 x 50|
|type320x100|320 x 100|
|type300x100|300 x 100|
|type300x250|300 x 250|
|type728x90|728 x 90|

### BannerAd API
BannerAdController will be returned when created BannerAd (onCreated).
You can controll BannerAd by using the instance.
The following APIs are available.
```Dart
final adController = BannerAdController()
// Load the BannerAd.
adController.load(spotId: spotId, apiKey: apiKey);

// Show the BannerAd.
adController.show();

// Hide the BannerAd.
adController.hide();

// Resume periodical loading for the BannerAd.
adController.resume();

// Pause periodical loading for the BannerAd.
adController.pause();

// Dispose of the BannerAd.
adController.dispose();
```

### BannerAd Event Handling
To handle event, You can add BannerAdListener on creating BannerAd instance.
```Dart
typedef AdEventCallBack = void Function();

class BannerAdListener {
  BannerAdListener({
    this.onLoaded,
    this.onReceiveAd,
    this.onFailedToLoad,
    this.onInformationClicked,
    this.onAdClicked,
  });

  /// Called when successfully loaded the BannerAd.
  final AdEventCallBack? onLoaded;

  /// Called when received the BannerAd.
  final AdEventCallBack? onReceiveAd;

  /// Called when failed to load the BannerAd.
  final AdEventCallBack? onFailedToLoad;

  /// Called when the information button clicked.
  final AdEventCallBack? onInformationClicked;

  /// Called when the BannerAd clicked.
  final AdEventCallBack? onAdClicked;
}
```
## InterstitialAd
Since InterstitialAd is displayed on Native View, it is not necessary to add to WidgetTree.
This class implemented with a singleton pattern.

### Example
```Dart
final _interstitial = InterstitialAd();
await _interstitial.loadAd(spotId: spotId, apiKey: apiKey)
await _interstitial.showAd(spotId: spotId);
```

### InterstitialAd API
```Dart
final _interstitial = InterstitialAd();

// Load the InterstitialAd.
await _interstitial.loadAd(spotId: spotId, apiKey: apiKey);

// Show the InterstitialAd.
// Need the spotId of the loaded InterstitialAd.
await _interstitial.showAd(spotId: spotId);

// Dismiss the InterstitialAd.
await _interstitial.dismissAd();

// Can set whether to load the InterstitialAd automatically when closed the InterstitialAd.
// This default value is true.
await enableAutoReload(isEnabled: isEnabled)

// Set the event listener.
_interstitial.setEventListener(_listener());
```

### InterstitialAd Event Handling
To handle event, You can add InterstitialAdListener by using `setEventListener` method.
```Dart
typedef AdEventCallBack = void Function();
typedef AdEventCallBackUseArgument = void Function(Object arg);

class InterstitialAdListener {
  InterstitialAdListener({
    this.onShown,
    this.onFailedToShow,
    this.onLoaded,
    this.onFailedToLoad,
    this.onAdClicked,
    this.onInformationClicked,
    this.onClosed,
  });

  /// Called when successfully displayed the InterstitialAd.
  /// This argument has the message for the result.
  /// Usage:
  /// ``` Dart
  /// onShown: (Object? arg) {
  ///   print((arg as Map)['result']);
  /// },
  /// ```
  final AdEventCallBackUseArgument? onShown;

  /// Called when display failed.
  /// This argument has the error message.
  /// Usage:
  /// ``` Dart
  /// onFailedToShow: (Object? arg) {
  ///   print((arg as Map)['result']);
  /// },
  /// ```
  final AdEventCallBackUseArgument? onFailedToShow;

  /// Called when successfully loaded the InterstitialAd.
  /// This argument has the message for the result.
  /// Usage:
  /// ``` Dart
  /// onLoaded: (Object? arg) {
  ///   print((arg as Map)['result']);
  /// },
  /// ```
  final AdEventCallBackUseArgument? onLoaded;

  /// Called when load failed.
  /// This argument has the error message.
  /// Usage:
  /// ``` Dart
  /// onFailedToLoad: (Object? arg) {
  ///   print((arg as Map)['result']);
  /// },
  /// ```
  final AdEventCallBackUseArgument? onFailedToLoad;

  /// Called when the InterstitialAd clicked.
  final AdEventCallBack? onAdClicked;

  /// Called when the information button clicked.
  final AdEventCallBack? onInformationClicked;

  /// Called when the close button clicked.
  final AdEventCallBack? onClosed;
}
```
## InterstitialVideoAd
Since InterstitialVideoAd is displayed on Native View, it is not necessary to add to WidgetTree.
This class implemented with a singleton pattern.
### Example
```Dart
InterstitialVideoAd? interstitialVideoAd;
interstitialVideoAd = InterstitialVideoAd(
  spotId: interstitialSpotId,
  apiKey: interstitialApiKey,
);
await interstitialVideoAd.loadAd();
await interstitialVideoAd.showAd();
```

### InterstitialVideoAd API
```Dart
InterstitialVideoAd? interstitialVideoAd;

// Can confirm if the VideoAd can play the video.
await interstitialAd.isReady();

// Load the VideoAd.
await interstitialVideoAd.loadAd();

// Show the VideoAd.
await interstitialVideoAd.showAd();

// Release the VideoAd.
await interstitialVideoAd.releaseAd();

// Set the event listener.
interstitialVideoAd.setEventListener(_interstitialAdListener());
// Option

// Register ad space of the fullscreen ads.
interstitialVideoAd.addFallbackFullboard(spotId: spotId, apiKey: apiKey);

// Set mute to play the InterstitialVideoAd.
// The default value is true.
interstitialVideoAd.muteStartPlaying = false;

```

### About the addFallbackFullboard.
If can not display the InterstitialVideoAd for reasons such as out of stock, can display fullscreen ads instead.  
In order to use this function, you need to register ad space of fullscreen ads separately on nend console.

### InterstitialVideoAd Event Handling
To handle event, You can add InterstitialVideoAdListener by using `setEventListener` method.

```Dart
typedef AdEventCallBack = void Function();

class InterstitialVideoAdListener {
  InterstitialVideoAdListener({
    this.onLoaded,
    this.onFailedToLoad,
    this.onFailedToPlay,
    this.onShown,
    this.onClosed,
    this.onStarted,
    this.onStopped,
    this.onCompleted,
    this.onAdClicked,
    this.onInformationClicked,
  });

  /// Called when successfully loaded the InterstitialVideoAd.
  final AdEventCallBack? onLoaded;

  /// Called when failed to load the InterstitialVideoAd.
  final AdEventCallBack? onFailedToLoad;

  /// Called when failed to play the InterstitialVideoAd.
  final AdEventCallBack? onFailedToPlay;

  /// Called when successfully displayed the InterstitialVideoAd.
  final AdEventCallBack? onShown;

  /// Called when the InterstitialVideoAd closed.
  final AdEventCallBack? onClosed;

  /// Called when started playing the video.
  final AdEventCallBack? onStarted;

  /// Called when stopped playing the video.
  final AdEventCallBack? onStopped;

  /// Called when completed playing the video.
  final AdEventCallBack? onCompleted;

  /// Called when the InterstitialVideoAd clicked.
  final AdEventCallBack? onAdClicked;

  /// Called when the information button clicked.
  final AdEventCallBack? onInformationClicked;
}
```
## RewardedVideoAd
Since RewardedVideoAd is displayed on Native View, It is not necessary to add to WidgetTree.
This class implemented with a singleton pattern.
### Example
```Dart
RewardedVideoAd? rewardedVideo;
rewardedVideo = RewardedVideoAd(
  spotId: spotId,
  apiKey: apiKey,
);
await rewardedVideo.loadAd();
await rewardedVideo.showAd();
```

### RewardedVideoAd API
```Dart
RewardedVideoAd? rewardedVideo;

// Can confirm if the VideoAd can play the video.
await rewardedVideo.isReady();

// Load the VideoAd.
await rewardedVideo.loadAd();

// Show the VideoAd.
await rewardedVideo.showAd();

// Release the VideoAd.
await rewardedVideo.releaseAd();

// Set the event listener.
rewardedVideo.setEventListener(_interstitialAdListener());

```

### RewardedVideoAd Event Handling
To handle event, You can add RewardedVideoAdListener by using `setEventListener` method.

```Dart
typedef AdEventCallBack = void Function();
typedef AdEventCallBackUseArgument = void Function(Object arg);

class RewardedVideoAdListener {
  RewardedVideoAdListener({
    required this.onRewarded,
    this.onLoaded,
    this.onFailedToLoad,
    this.onFailedToPlay,
    this.onShown,
    this.onClosed,
    this.onStarted,
    this.onStopped,
    this.onCompleted,
    this.onAdClicked,
    this.onInformationClicked,
  });

  /// Called when received reward item.
  /// This argument have a currency's name and a currency's amount.
  /// Usage:
  /// ```Dart
  /// onRewarded: (arg) {
  ///   reward = (arg as Map)['reward'];
  ///   final name = reward['name'];
  ///   final amount = reward['amount'];
  ///
  ///   ...
  /// },
  /// ```
  final AdEventCallBackUseArgument onRewarded;

  /// Called when successfully loaded the RewardedVideoAd.
  final AdEventCallBack? onLoaded;

  /// Called when failed to load the RewardedVideoAd.
  final AdEventCallBack? onFailedToLoad;

  /// Called when failed to play the RewardedVideoAd.
  final AdEventCallBack? onFailedToPlay;

  /// Called when successfully displayed the RewardedVideoAd.
  final AdEventCallBack? onShown;

  /// Called when the RewardedVideoAd closed.
  final AdEventCallBack? onClosed;

  /// Called when started playing the video.
  final AdEventCallBack? onStarted;

  /// Called when stopped playing the video.
  final AdEventCallBack? onStopped;

  /// Called when completed playing the video.
  final AdEventCallBack? onCompleted;

  /// Called when the RewardedVideoAd clicked.
  final AdEventCallBack? onAdClicked;

  /// Called when the information button clicked.
  final AdEventCallBack? onInformationClicked;
}
```
