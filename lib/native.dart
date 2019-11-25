import 'package:flutter/services.dart';
import 'package:nend_plugin/nend_plugin.dart';
import 'dart:async';
import 'package:flutter/material.dart';

/// Load native ad. See for [example:](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-native-ads#load-native-ad)
class NativeAdLoader {
  static const String tag = 'NendAdNativeClient';
  static Set<String> _registeredAdUnit = Set<String>();

  final int spotId;
  final String apiKey;
  String get _mappingId => this.hashCode.toString();
  Map simpleMappingArgument;
  final NativeAdLoaderListener listener;

  NativeAdLoader(this.spotId, this.apiKey, this.listener) {
    if (_registeredAdUnit.contains(this.spotId.toString())) {
      var message =
          "This NativeAdLoader already created. Please release old object before create new one.";
      throw new StateError(message);
    }
    _registeredAdUnit.add(this.spotId.toString());
    NendPlugin.invoke(
        _mappingId, NativeAdLoader.tag, NendPlugin.method_name_init,
        argument: {
          NendPlugin.key_mapping_id: _mappingId,
          NendPlugin.key_ad_unit: {
            NendPlugin.key_spot_id: spotId,
            NendPlugin.key_api_key: apiKey
          }
        });
    NendPlugin.addListener(_mappingId, this);
  }

  /// Load the ad. It is also possible to specify the reload interval time. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-native-ads#auto-reload-of-ads).
  Future<void> loadAd({int intervalMillis}) async {
    if (intervalMillis == null) {
      NendPlugin.invoke(
          _mappingId, NativeAdLoader.tag, NendPlugin.method_name_load_ad);
    } else {
      autoReloadIntervalMillis = intervalMillis;
    }
  }

  NativeAd _parseNativeAd(Map<String, dynamic> map) {
    var adMap = map['nativeAd'];
    NativeAd nativeAd = NativeAd._internal(
        adMap['titleText'],
        adMap['contentText'],
        adMap['promotionName'],
        adMap['promotionUrl'],
        adMap['adImageUrl'],
        adMap['logoImageUrl'],
        adMap['actionButtonText'],
        adMap['hashCode']);
    return nativeAd;
  }

  int _autoReloadIntervalMillis = 0;
  /// You can also use this property to stop auto-reload. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-native-ads#auto-reload-of-ads).
  get autoReloadIntervalMillis => _autoReloadIntervalMillis;
  set autoReloadIntervalMillis(int milliSec) {
    if (milliSec < 30000 && _autoReloadIntervalMillis > 0) {
      NendPlugin.invoke(_mappingId, NativeAdLoader.tag, '.disableAutoReload');
      _autoReloadIntervalMillis = milliSec;
    } else {
      _autoReloadIntervalMillis = milliSec;
      _enableAutoReload();
    }
  }

  Future<void> _enableAutoReload() async {
    NendPlugin.invoke(_mappingId, tag, '.enableAutoReload',
        argument: {'intervalMillis': _autoReloadIntervalMillis});
  }

  /// Release NativeAdLoader. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-native-ads#release-nativeadloader).
  void releaseLoader() async {
    _registeredAdUnit.remove(this.spotId.toString());
    await NendPlugin.invoke(
        _mappingId, NativeAdLoader.tag, NendPlugin.method_name_dispose);
  }

  dynamic eventFrom(String type) {
    type = type.split(".").last;
    type = 'NativeAdLoaderEvent.$type';
    return NativeAdLoaderEvent.values
        .firstWhere((event) => event.toString() == type, orElse: () => null);
  }

  void notify(MethodCall call) {
    NativeAdLoaderEvent event = eventFrom(call.method);
    Map<String, dynamic> map = call.arguments;
    if (event == NativeAdLoaderEvent.onFailedToLoad) {
      int code = int.parse(map[NendPlugin.key_error_code].toString());
      listener(event, errorCode: code);
    } else {
      listener(event, ad: _parseNativeAd(call.arguments));
    }
  }
}

/// Receive the result of ad loading. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-native-ads#load-native-ad).
enum NativeAdLoaderEvent {
  onLoaded,
  onFailedToLoad,
}

typedef void NativeAdLoaderListener(NativeAdLoaderEvent event,
    {int errorCode, NativeAd ad});

/// It is required to display the ad explicitly. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-native-ads#example-of-using-getadvertisingexplicitlywidget).
class AdvertisingExplicitlyWidget extends GestureDetector {
  final Widget child;
  final GestureTapCallback onTap;

  AdvertisingExplicitlyWidget(Key key, {this.onTap, this.child})
      : super(key: key);
}

/// Acquire each ad data from the [NativeAd](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-native-ads#acquire-each-ad-data-from-the-nativead).
class NativeAd {
  static const String tag = 'NendNativeAdConnector';

  final String _mappingId;
  final String titleText;
  final String contentText;
  final String promotionName;
  final String promotionUrl;
  final String adImageUrl;
  final String logoImageUrl;
  final String actionButtonText;

  bool _isActivated = false;
  GlobalKey _globalAdvertisingExplicitlyKey = GlobalKey();

  factory NativeAd() {
    var message = "Not support this operation.";
    throw new StateError(message);
  }

  NativeAd._internal(
      this.titleText,
      this.contentText,
      this.promotionName,
      this.promotionUrl,
      this.adImageUrl,
      this.logoImageUrl,
      this.actionButtonText,
      this._mappingId);

  NativeAdListener _listener;
  NativeAdListener get listener => _listener;
  /// Register the listener to receive the ad event. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-native-ads#receive-ad-event).
  set listener(NativeAdListener value) {
    _listener = value;
    NendPlugin.addListener(tag, this);
  }

  static String _getAdvertisingExplicitlyText(AdvertisingExplicitly type) {
    switch (type) {
      case AdvertisingExplicitly.PR:
        return "PR";
      case AdvertisingExplicitly.Sponsored:
        return "Sponsored";
      case AdvertisingExplicitly.AD:
        return "広告";
      case AdvertisingExplicitly.Promotion:
        return "プロモーション";
      default:
        throw new StateError("Unknown AdvertisingExplicitly type...");
    }
  }

  AdvertisingExplicitlyWidget getAdvertisingExplicitlyWidget(
      AdvertisingExplicitly type,
      {TextStyle style}) {
    Widget text = (style == null
        ? Text(NativeAd._getAdvertisingExplicitlyText(type))
        : Text(NativeAd._getAdvertisingExplicitlyText(type), style: style));
    return AdvertisingExplicitlyWidget(
      _globalAdvertisingExplicitlyKey,
      onTap: () {
        _performInformationClick();
      },
      child: Container(
        child: text,
      ),
    );
  }

  void _performAdClick() {
    if (_isActivated) {
      NendPlugin.invoke(_mappingId, NativeAd.tag, '.performAdClick');
      if (_listener != null) {
        _listener(NativeAdEvent.onClickAd);
      }
    }
  }

  void _performInformationClick() {
    NendPlugin.invoke(_mappingId, NativeAd.tag, '.performInformationClick');
    if (_listener != null) {
      _listener(NativeAdEvent.onClickInformation);
    }
  }

  void _activate() {
    if (!_isActivated) {
      NendPlugin.invoke(_mappingId, NativeAd.tag, '.activate');
      _isActivated = true;
      if (_listener != null) {
        _listener(NativeAdEvent.onImpression);
      }
    }
  }

  void _deactivate() {
    NendPlugin.invoke(_mappingId, NativeAd.tag, NendPlugin.method_name_dispose);
  }
}

/// Receive the ad event. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-native-ads#receive-ad-event).
enum NativeAdEvent { onImpression, onClickAd, onClickInformation }

/// About [AdvertisingExplicitly](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-native-ads#advertisingexplicitly).
enum AdvertisingExplicitly { PR, Sponsored, AD, Promotion }

typedef void NativeAdListener(NativeAdEvent event);

/// Connect between ad information and Widget. See for [example](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-native-ads#generate-nativeadbinder).
class NativeAdBinder extends StatefulWidget {
  final Widget _adContainer;
  final Stream<NativeAd> _streamNativeAd;

  NativeAdBinder(this._streamNativeAd, this._adContainer);

  @override
  _NativeAdBinder createState() => new _NativeAdBinder();
}

class _NativeAdBinder extends State<NativeAdBinder>
    with WidgetsBindingObserver {
  GlobalKey _globalKey = GlobalKey();
  Timer _viewableChecker;
  NativeAd _nativeAd;
  bool _hasAdvertisingExplicitlyElement = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NativeAd>(
        stream: widget._streamNativeAd,
        builder: (BuildContext context, AsyncSnapshot<NativeAd> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                _nativeAd = snapshot.data;
              }
              break;
            default:
              break;
          }
          return Container(
            key: _globalKey,
            child: GestureDetector(
              onTap: () {
                _nativeAd._performAdClick();
              },
              child: widget._adContainer,
            ),
          );
        });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_nativeAd != null) {
      _nativeAd._deactivate();
    }
    _stopViewableChecker();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.didChangeMetrics();
  }

  _afterLayout(_) {
    if (_nativeAd != null && !_nativeAd._isActivated && _isViewable()) {
      _stopViewableChecker();
      _activateIfFoundNativeAdElement(_globalKey.currentContext);
    } else if (_viewableChecker == null) {
      _viewableChecker = Timer.periodic(Duration(seconds: 1), (_) {
        _afterLayout(_);
      });
    }
  }

  void _activateIfFoundNativeAdElement(BuildContext context) {
    if (_nativeAd._isActivated) {
      return;
    }
    context.visitChildElements((visitor) {
      if (!_hasAdvertisingExplicitlyElement &&
          visitor.widget is AdvertisingExplicitlyWidget) {
        _hasAdvertisingExplicitlyElement = true;
      }

      if (_hasAdvertisingExplicitlyElement) {
        _nativeAd._activate();
      } else {
        _activateIfFoundNativeAdElement(visitor);
      }
    });
  }

  void _stopViewableChecker() {
    if (_viewableChecker != null) {
      _viewableChecker.cancel();
      _viewableChecker = null;
    }
  }

  bool _isViewable() {
    final RenderBox renderBox = _globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    //TODO: Re-enable after implemented logging function -> print('position: $position');
    final binderSize = renderBox.size;
    //TODO: Re-enable after implemented logging function -> print('binderSize: $binderSize');
    final displaySize = MediaQuery.of(context).size;
    //TODO: Re-enable after implemented logging function -> print('displaySize: $displaySize');

    Rect rect = Rect.fromLTWH(0, 0, displaySize.width, displaySize.height);
    return rect.contains(position) &&
        _isOver50percent(position, binderSize, displaySize);
  }

  //Note : We can't detect drawn position parent Widget of binder from Plugin-layer...
  //       So this checking will not be working if app's-layer has NavigationBar, SafeArea (;∀;)
  bool _isOver50percent(Offset position, Size binderSize, Size displaySize) {
    bool checkPositionX = (position.dx < 0
        ? binderSize.width / 2 < binderSize.width - position.dx
        : displaySize.width - position.dx > binderSize.width / 2);
    bool checkPositionY = (position.dy < 0
        ? binderSize.height / 2 < binderSize.height - position.dy
        : displaySize.height - position.dy > binderSize.height / 2);
    //TODO: Re-enable after implemented logging function -> print('checkPositionX: $checkPositionX');
    //TODO: Re-enable after implemented logging function -> print('checkPositionY: $checkPositionY');

    return checkPositionX && checkPositionY;
  }
}
