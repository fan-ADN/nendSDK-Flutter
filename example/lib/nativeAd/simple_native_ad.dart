import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:nend_plugin_example/main.dart';
import 'package:nend_plugin/native.dart';

const _menu = [
  'Load',
  'Load with interval 30 sec',
  'Set interval to 29 sec',
  'Release loader'
];

class NativeAdSimpleSample extends StatefulWidget {
  @override
  _NativeAdState createState() => new _NativeAdState();
}

class _NativeAdState extends State<NativeAdSimpleSample>
    with WidgetsBindingObserver {
  NativeAdLoader _loader;
  NativeAd _nativeAd;
  NativeAdBinder _binder;

  String _nativeAdLoaderState = 'NativeAd';
  String _nativeAdState = 'NativeAd';
  String _title = 'NativeAd example';
  int _loadedCounter = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _loader = new NativeAdLoader(spotId, apiKey,
        (NativeAdLoaderEvent loaderEvent, {int errorCode, NativeAd ad}) {
      setState(() {
        if (loaderEvent == NativeAdLoaderEvent.onFailedToLoad) {
          _nativeAdLoaderState =
              loaderEvent.toString() + ' errorCode: $errorCode';
        } else {
          _loadedCounter++;
          _nativeAd = ad;
          _nativeAd.listener = (NativeAdEvent adEvent) {
            setState(() {
              _nativeAdState = adEvent.toString();
              print('NativeAd ' + _nativeAdState);
            });
          };
          _nativeAdLoaderState =
              loaderEvent.toString() + ' count:$_loadedCounter';
        }
        print('NativeAd ' + _nativeAdLoaderState);
      });
    });
  }

  Stream<NativeAd> _streamNativeAd() async* {
    yield _nativeAd;
  }

  @override
  Widget build(BuildContext context) {
    var popupMenu = List<PopupMenuEntry<String>>();
    _menu.forEach((key) {
      popupMenu.add(PopupMenuItem<String>(
        value: key,
        key: Key(key.toString()),
        child: Text(key.toString()),
      ));
    });

    List<Widget> children = List<Widget>();

    //Note: Only added for integration test and doesn't need visible for human
    children.add(new StateDisplay(
      title: 'LoaderStateDisplay',
      state: _nativeAdLoaderState,
      color: Colors.transparent,
    ));
    children.add(new StateDisplay(
      title: 'AdStateDisplay',
      state: _nativeAdState,
      color: Colors.black,
    ));

    if (_nativeAd != null) {
      var card = Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(_nativeAd.adImageUrl),
            _titleArea(),
            _descriptionArea(),
            _buildButton()
          ],
        ),
      );
      _binder = NativeAdBinder(_streamNativeAd(), card);
      children.add(_binder);
      _title = _nativeAd.titleText;
    }

    return new Scaffold(
      appBar: new AppBar(
        title: Text(_title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String key) {
              switch (key) {
                case 'Load':
                  _loader.loadAd();
                  break;
                case 'Release loader':
                  _loader.releaseLoader();
                  break;
                case 'Load with interval 30 sec':
                  _loader.loadAd(intervalMillis: 30000);
                  break;
                case 'Set interval to 29 sec':
                  _loader.autoReloadIntervalMillis =
                      29999; //Note: It's not same meant menu name because for checking threshold value..
                  setState(() {
                    _nativeAdLoaderState = 'NativeAd';
                  });
                  break;
              }
            },
            itemBuilder: (BuildContext context) => popupMenu,
            key: Key('PopupMenuButton'),
          )
        ],
      ),
      body: new Stack(
        children: children,
      ),
    );
  }

  int get spotId {
    return (Platform.isAndroid ? 485520 : 485504);
  }

  String get apiKey {
    return (Platform.isAndroid
        ? "a88c0bcaa2646c4ef8b2b656fd38d6785762f2ff"
        : "30fda4b3386e793a14b27bedb4dcd29f03d638e5");
  }

  Widget _titleArea() {
    return Container(
        margin: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Image.network(_nativeAd.logoImageUrl),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      _nativeAd.promotionName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                  Container(
                    child: Text(
                      _nativeAd.promotionUrl,
                      style: TextStyle(fontSize: 12.0, color: Colors.blue),
                    ),
                  ),
                  _nativeAd.getAdvertisingExplicitlyWidget(
                      AdvertisingExplicitly.Sponsored,
                      style: TextStyle(fontSize: 12.0, color: Colors.red))
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildButton() {
    return RaisedButton(
        textColor: Colors.white,
        padding: const EdgeInsets.all(0.0),
        child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFF0D47A1),
                  Color(0xFF1976D2),
                  Color(0xFF42A5F5),
                ],
              ),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(_nativeAd.actionButtonText,
                key: Key('actionButtonText'), style: TextStyle(fontSize: 20))));
  }

  Widget _descriptionArea() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Text(_nativeAd.contentText),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _loader.releaseLoader();
    super.dispose();
  }
}
