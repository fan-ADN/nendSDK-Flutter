import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:nend_plugin_example/main.dart';
import 'package:nend_plugin/native.dart';

const _menu = [
  'x position to 0.0',
  'y position to 0.0',
  'Top Left',
  'Top Right',
  'Bottom Left',
  'Bottom Right',
  'Reload'
];

const String nativeAdState = 'NativeAd';

class NativeAdPositionatedStackSample extends StatefulWidget {
  @override
  _NativeAdState createState() => new _NativeAdState();
}

class _NativeAdState extends State<NativeAdPositionatedStackSample>
    with WidgetsBindingObserver {
  NativeAdLoader _loader;
  NativeAd _nativeAd;
  NativeAdBinder _binder;

  String _nativeAdLoaderState = nativeAdState;
  String _nativeAdState = nativeAdState;
  int _loadedCounter = 0;

  String _title = 'NativeAd example';
  double _width = 200.0;
  double _height = 100.0;
  double _xPosition;
  double _yPosition;
  ContainerPosition _placePosition = ContainerPosition.rightBottom;

  @override
  void initState() {
    _xPosition = -(_width / 2 + 10);
    _yPosition = -(_height / 2 + 10);

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
    _loader.loadAd();
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

    if (_nativeAd != null) {
      _binder = NativeAdBinder(
          _streamNativeAd(),
          ListTile(
            title: _nativeAd.getAdvertisingExplicitlyWidget(_getType),
            subtitle: Text(_nativeAd.titleText),
            isThreeLine: true,
          ));
      _title = _nativeAd.titleText;
    }

    var adContainer;
    switch (_placePosition) {
      case ContainerPosition.leftTop:
        adContainer = Positioned(
          left: _xPosition,
          top: _yPosition,
          width: _width,
          height: _height,
          child: Container(
            color: Colors.orange,
            child: _binder,
          ),
        );
        break;
      case ContainerPosition.rightTop:
        adContainer = Positioned(
          right: _xPosition,
          top: _yPosition,
          width: _width,
          height: _height,
          child: Container(
            color: Colors.orange,
            child: _binder,
          ),
        );
        break;
      case ContainerPosition.leftBottom:
        adContainer = Positioned(
          left: _xPosition,
          bottom: _yPosition,
          width: _width,
          height: _height,
          child: Container(
            color: Colors.orange,
            child: _binder,
          ),
        );
        break;
      case ContainerPosition.rightBottom:
      default:
        adContainer = Positioned(
          right: _xPosition,
          bottom: _yPosition,
          width: _width,
          height: _height,
          child: Container(
            color: Colors.orange,
            child: _binder,
          ),
        );
        break;
    }

    return new Scaffold(
      appBar: new AppBar(
        title: Text(_title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String key) {
              switch (key) {
                case 'Reload':
                  setState(() {
                    _nativeAdState = nativeAdState;
                  });
                  _loader.loadAd();
                  break;
                case 'x position to 0.0':
                  setState(() {
                    _xPosition = 0.0;
                  });
                  break;
                case 'y position to 0.0':
                  setState(() {
                    _yPosition = 0.0;
                  });
                  break;
                case 'Top Left':
                  setState(() {
                    _placePosition = ContainerPosition.leftTop;
                  });
                  break;
                case 'Top Right':
                  setState(() {
                    _placePosition = ContainerPosition.rightTop;
                  });
                  break;
                case 'Bottom Left':
                  setState(() {
                    _placePosition = ContainerPosition.leftBottom;
                  });
                  break;
                case 'Bottom Right':
                  setState(() {
                    _placePosition = ContainerPosition.rightBottom;
                  });
                  break;
              }
            },
            itemBuilder: (BuildContext context) => popupMenu,
            key: Key('PopupMenuButton'),
          )
        ],
      ),
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          adContainer,
          Center(
            child: Container(
              color: Colors.cyan,
              margin: const EdgeInsets.all(32.0),
              child: NativeAdBinder(
                  _streamNativeAd(),
                  Card(
                    elevation: 4.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.network(
                            'https://4.bp.blogspot.com/-f7o29_sqb7Y/Wo8VPH5g14I/AAAAAAAAIOw/yxksrWuXD6Qxk9auMKruANWRpBvE09gmwCLcBGAs/s320/dart2.jpg'),
                        Text('Invalid binder', key: Key('Invalid binder')),
                      ],
                    ),
                  )),
            ),
          ),
          StateDisplay(
            title: 'LoaderStateDisplay',
            state: _nativeAdLoaderState,
            color: Colors.transparent,
          ),
          StateDisplay(
            title: 'StateDisplay',
            state: _nativeAdState,
            color: Colors.black,
          )
        ],
      )),
    );
  }

  AdvertisingExplicitly get _getType {
    switch (_placePosition) {
      case ContainerPosition.leftTop:
        return AdvertisingExplicitly.PR;
      case ContainerPosition.rightTop:
        return AdvertisingExplicitly.Sponsored;
      case ContainerPosition.leftBottom:
        return AdvertisingExplicitly.AD;
      default:
        //case ContainerPosition.rightBottom:
        return AdvertisingExplicitly.Promotion;
    }
  }

  int get spotId {
    return (Platform.isAndroid ? 485522 : 485507);
  }

  String get apiKey {
    return (Platform.isAndroid
        ? "2b2381a116290c90b936e409482127efb7123dbc"
        : "31e861edb574cfa0fb676ebdf0a0b9a0621e19fc");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _loader.releaseLoader();
    super.dispose();
  }
}

enum ContainerPosition {
  leftTop,
  rightTop,
  leftBottom,
  rightBottom,
}
