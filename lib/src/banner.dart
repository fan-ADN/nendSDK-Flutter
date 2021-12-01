import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'nend_plugin.dart';

/// Create a BannerAd. This widget can add to the widget tree.
/// Use PlatformView to display the native view.
class BannerAd extends StatefulWidget {
  BannerAd({
    required this.bannerSize,
    required this.listener,
    required this.onCreated,
    this.adjustSize = false,
  });

  /// Size of the BannerAd.
  final BannerSize bannerSize;

  /// See also [BannerAdListener].
  final BannerAdListener listener;

  /// Callback invoked after the PlatformView has been created.
  ///　This argument's controller is needed to control the BannerAd.
  /// Usage
  /// ```Dart
  /// onCreated: (controller) {
  ///   adController = controller;
  ///   adController.load(spotId: spotId, apiKey: apiKey);
  /// },
  /// ```
  final ValueChanged<BannerAdController> onCreated;

  /// If adjustSize is true, the BannerAd is scaled automatically.
  /// It will be calculated in the width ratio of 320(up to 1.5).
  /// This property default false.
  final bool adjustSize;

  @override
  _BannerAdState createState() => _BannerAdState();
}

class _BannerAdState extends State<BannerAd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _adjustFromSize(widget.adjustSize, widget.bannerSize.height),
      width: _adjustFromSize(widget.adjustSize, widget.bannerSize.width),
      child: Center(
        child: Platform.isAndroid
            ? PlatformViewLink(
                viewType: 'nend_plugin/banner',
                surfaceFactory:
                    (BuildContext context, PlatformViewController controller) {
                  return AndroidViewSurface(
                    controller: controller as AndroidViewController,
                    gestureRecognizers: const <
                        Factory<OneSequenceGestureRecognizer>>{},
                    hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                  );
                },
                onCreatePlatformView: (PlatformViewCreationParams params) {
                  return PlatformViewsService.initSurfaceAndroidView(
                    id: params.id,
                    viewType: 'nend_plugin/banner',
                    layoutDirection: TextDirection.ltr,
                  )
                    ..addOnPlatformViewCreatedListener(
                        params.onPlatformViewCreated)
                    ..addOnPlatformViewCreatedListener((int id) {
                      _onPlatformViewCreated(id);
                    })
                    ..create();
                },
              )
            : UiKitView(
                viewType: 'nend_plugin/banner',
                creationParamsCodec: const StandardMessageCodec(),
                onPlatformViewCreated: (id) => _onPlatformViewCreated(id),
              ),
      ),
    );
  }

  double _adjustFromSize(bool needAdjust, double size) {
    if (needAdjust) {
      final maxRatio = 1.5;
      final query = MediaQuery.of(context);
      final base = query.orientation == Orientation.portrait
          ? query.size.width
          : query.size.height;
      final ratio = min(base / (320 * query.devicePixelRatio), maxRatio);
      return size * query.devicePixelRatio * ratio;
    }
    return size;
  }

  void _onPlatformViewCreated(id) {
    final controller = BannerAdController(
      viewId: id,
      adjustSize: widget.adjustSize,
    );
    controller.channel.setMethodCallHandler((call) => _handler(call));
    widget.onCreated.call(controller);
  }

  Future<void> _handler(MethodCall call) async {
    final listener = widget.listener;
    switch (call.method) {
      case 'onLoaded':
        final onLoaded = listener.onLoaded;
        if (onLoaded != null) {
          onLoaded();
        }
        break;
      case 'onReceiveAd':
        final onReceiveAd = listener.onReceiveAd;
        if (onReceiveAd != null) {
          onReceiveAd();
        }
        break;
      case 'onFailedToLoad':
        final onFailedToLoad = listener.onFailedToLoad;
        if (onFailedToLoad != null) {
          onFailedToLoad();
        }
        break;
      case 'onInformationClicked':
        final onInformationClicked = listener.onInformationClicked;
        if (onInformationClicked != null) {
          onInformationClicked();
        }
        break;
      case 'onAdClicked':
        final onAdClicked = listener.onAdClicked;
        if (onAdClicked != null) {
          onAdClicked();
        }
        break;
      default:
        break;
    }
  }
}

/// Controls a BannerAd.
class BannerAdController {
  BannerAdController({
    required this.viewId,
    required this.adjustSize,
  });

  ///  The viewId is the PlatformView's unique identifier.
  final int viewId;

  /// If adjustSize is true, the BannerAd is scaled automatically.
  /// It will be calculated in the width ratio of 320(up to 1.5).
  /// This argument default false.
  final bool adjustSize;

  late final channel = MethodChannel(
    'nend_plugin/banner/$viewId',
    JSONMethodCodec(),
  );

  final String className = 'NendAdView';

  /// Load the BannerAd.
  Future<void> load({
    required int spotId,
    required String apiKey,
  }) async {
    NendPlugin.invokeMethod(
      channel: channel,
      method: NendPlugin.method_name_load_ad,
      argument: {
        'adjustSize': adjustSize,
        NendPlugin.key_ad_unit: {
          NendPlugin.key_spot_id: spotId,
          NendPlugin.key_api_key: apiKey
        }
      },
    );
  }

  /// Show the BannerAd.
  Future<void> show() async {
    await NendPlugin.invokeMethod(
      channel: channel,
      method: NendPlugin.method_name_show_ad,
    );
  }

  /// Hide the BannerAd.
  Future<void> hide() async {
    await NendPlugin.invokeMethod(
      channel: channel,
      method: NendPlugin.method_name_hide_ad,
    );
  }

  /// Resume periodical loading for the BannerAd.
  Future<void> resume() async {
    await NendPlugin.invokeMethod(channel: channel, method: 'resume');
  }

  /// Pause periodical loading for the BannerAd.
  Future<void> pause() async {
    await NendPlugin.invokeMethod(channel: channel, method: 'pause');
  }

  /// Dispose of the BannerAd.
  Future<void> dispose() async {
    await NendPlugin.invokeMethod(
      channel: channel,
      method: NendPlugin.method_name_release_ad,
    );
  }
}

/// Available banner sizes.
class BannerSize {
  const BannerSize({required this.width, required this.height});

  final double width;
  final double height;

  static const BannerSize type320x50 = BannerSize(width: 320, height: 50);

  static const BannerSize type320x100 = BannerSize(width: 320, height: 100);

  static const BannerSize type300x100 = BannerSize(width: 300, height: 100);

  static const BannerSize type300x250 = BannerSize(width: 300, height: 250);

  static const BannerSize type728x90 = BannerSize(width: 728, height: 90);
}

/// Can receive these events for the BannerAd.
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

  /// Called when receive the BannerAd.
  final AdEventCallBack? onReceiveAd;

  /// Called when failed to load the BannerAd.
  final AdEventCallBack? onFailedToLoad;

  /// Called when the information button clicked.
  final AdEventCallBack? onInformationClicked;

  /// Called when the BannerAd clicked.
  final AdEventCallBack? onAdClicked;
}
