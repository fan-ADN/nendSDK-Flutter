import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'nend_plugin.dart';

/// See for [details](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-banner-ads#banner-ad-implementation).
class BannerAd extends StatefulWidget {
  static const String tag = 'NendAdView';

  final int spotId;
  final String apiKey;
  final BannerSize type;
  final bool adjustSize;
  final BannerAdListener listener;

  @override
  _Banner createState() {
    NendPlugin.invoke(_mappingId, BannerAd.tag, NendPlugin.method_name_init,
        argument: {
          NendPlugin.key_mapping_id: _mappingId,
          'adjustSize': adjustSize,
          NendPlugin.key_ad_unit: {
            NendPlugin.key_spot_id: spotId,
            NendPlugin.key_api_key: apiKey
          }
        });
    return _Banner(_mappingId, type, adjustSize);
  }

  BannerAd(this.spotId, this.apiKey, this.type,
      {this.adjustSize, this.listener}) {
    if (listener != null) {
      NendPlugin.addListener(_mappingId, this);
    }
  }

  dynamic eventFrom(String type) {
    type = type.split(".").last;
    type = 'BannerAdEvent.$type';
    return BannerAdEvent.values
        .firstWhere((event) => event.toString() == type, orElse: () => null);
  }

  void notify(MethodCall call) {
    BannerAdEvent event = eventFrom(call.method);

    if (event == BannerAdEvent.onFailedToLoad) {
      Map<String, dynamic> map = call.arguments;
      int code = map[NendPlugin.key_error_code];
      listener(event, errorCode: code);
    } else {
      listener(event);
    }
  }

  String get _mappingId => this.hashCode.toString();

  /// Show banner ad. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-banner-ads#show-banner-ad).
  void show() {
    NendPlugin.invoke(_mappingId, BannerAd.tag, NendPlugin.method_name_show_ad);
  }

  /// Hide banner ad. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-banner-ads#hide-banner-ad).
  void hide() {
    NendPlugin.invoke(_mappingId, BannerAd.tag, NendPlugin.method_name_hide_ad);
  }

  /// Resume interval-loading. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-banner-ads#about-interval-loading).
  void resume() {
    NendPlugin.invoke(_mappingId, BannerAd.tag, '.resume');
  }

  /// Pause interval-loading. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-banner-ads#about-interval-loading).
  void pause() {
    NendPlugin.invoke(_mappingId, BannerAd.tag, '.pause');
  }

  /// Release banner ad. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-banner-ads#release-banner-ad)
  void releaseAd() {
    NendPlugin.invoke(_mappingId, BannerAd.tag, NendPlugin.method_name_hide_ad);
    NendPlugin.invoke(_mappingId, BannerAd.tag, NendPlugin.method_name_dispose);
  }
}

class _Banner extends State<BannerAd> with WidgetsBindingObserver {
  String _mappingId;

  BannerSize _sizeType = BannerSize.type320x50;
  bool _adjustSize = false;

  GlobalKey _globalKey = GlobalKey();
  double _x = 0;
  double _y = 0;

  _Banner(String mappingId, BannerSize type, bool adjustSize) {
    _adjustSize = adjustSize;
    _mappingId = mappingId;
    _sizeType = type;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    NendPlugin.invoke(_mappingId, BannerAd.tag, NendPlugin.method_name_hide_ad);
    NendPlugin.invoke(_mappingId, BannerAd.tag, NendPlugin.method_name_dispose);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: Key(BannerAd.tag),
      child: Container(
          key: _globalKey,
          color: Colors.transparent,
          width: _width,
          height: _height),
    );
  }

  _afterLayout(_) {
    final RenderBox renderBox = _globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);

    _x = position.dx;
    _y = position.dy;

    NendPlugin.invoke(_mappingId, BannerAd.tag, '.layout', argument: {
      'frame': {'x': _x, 'y': _y, 'width': _width, 'height': _height},
      NendPlugin.key_mapping_id: _mappingId
    });
  }

  double get _width => _adjustSideSize(_sizeType.width);
  double get _height => _adjustSideSize(_sizeType.height);

  double _adjustSideSize(double origin) {
    if (_adjustSize != true || _sizeType == BannerSize.type728x90) {
      return origin;
    }

    final queryData = MediaQuery.of(context);
    double screenMeasurement =
        (min(queryData.size.height, queryData.size.width) *
            queryData.devicePixelRatio);
    double ratio = screenMeasurement / (320 * queryData.devicePixelRatio);
    return origin * min(ratio, 1.5);
  }
}

/// See for [details](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-banner-ads#about-banner-size).
class BannerSize {
  const BannerSize._({@required this.width, @required this.height});

  final double width;
  final double height;

  static const BannerSize type320x50 = BannerSize._(width: 320, height: 50);

  static const BannerSize type320x100 = BannerSize._(width: 320, height: 100);

  static const BannerSize type300x100 = BannerSize._(width: 300, height: 100);

  static const BannerSize type300x250 = BannerSize._(width: 300, height: 250);

  static const BannerSize type728x90 = BannerSize._(width: 728, height: 90);
}

/// Receive the ad event. See for [details](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-banner-ads#banneradevent).
enum BannerAdEvent {
  onLoaded,
  onFailedToLoad,
  onInformationClicked,
  onAdClicked,
  //Note: It's unnecessary -> onComebackDisplay
}

typedef void BannerAdListener(BannerAdEvent event, {int errorCode});
