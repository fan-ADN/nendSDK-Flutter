import 'package:flutter/services.dart';
import 'nend_plugin.dart';

/// Create a InterstitialAd.
/// This class implemented with a singleton pattern.
class InterstitialAd {
  factory InterstitialAd() {
    return _interstitialAd;
  }

  InterstitialAd._();
  static final InterstitialAd _interstitialAd = InterstitialAd._();

  final channel = MethodChannel('nend_plugin/interstitial', JSONMethodCodec());

  void setEventListener(InterstitialAdListener listener) {
    channel.setMethodCallHandler(
      (call) => _handler(listener: listener, call: call),
    );
  }

  /// Load the InterstitialAd.
  Future<void> loadAd({required int spotId, required String apiKey}) async {
    await NendPlugin.invokeMethod(
      channel: channel,
      method: NendPlugin.method_name_load_ad,
      argument: {
        NendPlugin.key_spot_id: spotId,
        NendPlugin.key_api_key: apiKey,
      },
    );
  }

  /// Show the InterstitialAd.
  /// Need the spotId of the loaded InterstitialAd.
  Future<void> showAd({required int spotId}) async {
    await NendPlugin.invokeMethod(
      channel: channel,
      method: NendPlugin.method_name_show_ad,
      argument: {
        NendPlugin.key_spot_id: spotId,
      },
    );
  }

  /// Dismiss the InterstitialAd.
  Future<void> dismissAd() async {
    NendPlugin.invokeMethod(
      channel: channel,
      method: NendPlugin.method_name_dismiss_ad,
    );
  }

  /// Can set whether to load the InterstitialAd automatically when closed the InterstitialAd.
  /// This default value is true.
  Future<void> enableAutoReload({required bool isEnabled}) async {
    NendPlugin.invokeMethod(
      channel: channel,
      method: 'enableAutoReload',
      argument: {'enableAutoReload': isEnabled},
    );
  }

  Future<void> _handler({
    required InterstitialAdListener listener,
    required MethodCall call,
  }) async {
    switch (call.method) {
      case 'onShown':
        final onShown = listener.onShown;
        if (onShown != null) {
          onShown(call.arguments);
        }
        break;
      case 'onFailedToShow':
        final onFailedToShow = listener.onFailedToShow;
        if (onFailedToShow != null) {
          onFailedToShow(call.arguments);
        }
        break;
      case 'onLoaded':
        final onLoaded = listener.onLoaded;
        if (onLoaded != null) {
          onLoaded(call.arguments);
        }
        break;
      case 'onFailedToLoad':
        final onFailedToLoad = listener.onFailedToLoad;
        if (onFailedToLoad != null) {
          onFailedToLoad(call.arguments);
        }
        break;
      case 'onAdClicked':
        final onAdClicked = listener.onAdClicked;
        if (onAdClicked != null) {
          onAdClicked();
        }
        break;
      case 'onInformationClicked':
        final onInformationClicked = listener.onInformationClicked;
        if (onInformationClicked != null) {
          onInformationClicked();
        }
        break;
      case 'onClosed':
        final onClosed = listener.onClosed;
        if (onClosed != null) {
          onClosed();
        }
        break;
    }
  }
}

/// Can receive these events for the InterstitialAd.
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
