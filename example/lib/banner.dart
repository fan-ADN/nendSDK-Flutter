import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:nend_plugin/banner.dart';
import 'main.dart';

const menu = [
  'Show',
  'Hide',
  'Alignment.topLeft',
  'Alignment.topCenter',
  'Alignment.topRight',
  'Alignment.centerLeft',
  'Alignment.center',
  'Alignment.centerRight',
  'Alignment.bottomLeft',
  'Alignment.bottomCenter',
  'Alignment.bottomRight',
  'Pause',
  'Resume',
  'Release',
];

class AdjustBannerSample extends BannerSample {
  @override
  _BannerState createState() => new _BannerState(adjustSize: true);
}

class BannerSample extends StatefulWidget {
  @override
  _BannerState createState() => new _BannerState();
}

class _BannerState extends State<BannerSample> {
  BannerSize _selection;
  BannerAd _bannerAd;
  Alignment _alignment;

  List<BannerAd> bannerAdList = [];
  Map<String, BannerSize> sizeTypes = {
    'type320x50': BannerSize.type320x50,
    'type320x100': BannerSize.type320x100,
    'type300x100': BannerSize.type300x100,
    'type300x250': BannerSize.type300x250,
    'type728x90': BannerSize.type728x90
  };
  List<PopupMenuEntry<BannerSize>> popupMenus =
      List<PopupMenuEntry<BannerSize>>();
  String _bannerState = 'Banner';

  bool _adjustSize = false;
  _BannerState({bool adjustSize}) {
    if (adjustSize != null) {
      _adjustSize = adjustSize;
    }
  }

  @override
  void initState() {
    super.initState();
    sizeTypes.values.forEach((type) {
      _selection = type;
      BannerAd ad = BannerAd(spotId, apiKey, type, adjustSize: _adjustSize,
          listener: (BannerAdEvent event, {int errorCode}) {
        setState(() {
          if (event == BannerAdEvent.onFailedToLoad) {
            _bannerState = event.toString() + ' errorCode: $errorCode';
          } else {
            // Load success
            _bannerState = event.toString();
          }
          print('Banner ' + _bannerState);
        });
      });
      bannerAdList.add(ad);
    });
    _bannerAd = bannerAdList[0];
    _selection = sizeTypes[0];
    _alignment = Alignment.bottomCenter;
  }

  @override
  Widget build(BuildContext context) {
    var popupMenu = List<PopupMenuEntry<String>>();
    sizeTypes.keys.forEach((key) {
      popupMenu.add(PopupMenuItem<String>(
        value: key,
        key: Key(key.toString()),
        child: Text(key.toString()),
      ));
    });

    List<Widget> children = List<Widget>();

    bannerAdList.forEach((ad) {
      children.add(new Align(
        alignment: _alignment,
        child: Container(
          child: ad,
        ),
      ));
    });

    children.add(new StateDisplay(
      title: 'StateDisplay',
      state: _bannerState,
      color: Colors.transparent,  // It's OK transparent to human because this Widget only works for unit test.
    ));

    children.add(new ListView.builder(
      key: Key('menu_list'),
      padding: EdgeInsets.all(8.0),
      itemExtent: 44.0,
      itemCount: menu.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          key: Key(menu[index]),
          child: Text(menu[index]),
          onTapUp: (details) {
            setState(() {
              switch (menu[index]) {
                case 'Show':
                  _bannerAd.show();
                  break;
                case 'Hide':
                  _bannerAd.hide();
                  _bannerState = 'Hide banner'; // <- For unit test
                  break;
                case 'Pause':
                  _bannerAd.pause();
                  _bannerState = 'Pause banner'; // <- For unit test
                  break;
                case 'Resume':
                  _bannerAd.resume();
                  break;
                case 'Release':
                  _bannerAd.releaseAd();
                  break;

                // Note: If you want to change the position of Banner ad when clicked,
                //       create a widget of a banner ad on build scope, not on initState.
                case 'Alignment.topLeft':
                  _alignment = Alignment.topLeft;
                  break;
                case 'Alignment.topCenter':
                  _alignment = Alignment.topCenter;
                  break;
                case 'Alignment.topRight':
                  _alignment = Alignment.topRight;
                  break;
                case 'Alignment.centerLeft':
                  _alignment = Alignment.centerLeft;
                  break;
                case 'Alignment.center':
                  _alignment = Alignment.center;
                  break;
                case 'Alignment.centerRight':
                  _alignment = Alignment.centerRight;
                  break;
                case 'Alignment.bottomLeft':
                  _alignment = Alignment.bottomLeft;
                  break;
                case 'Alignment.bottomCenter':
                  _alignment = Alignment.bottomCenter;
                  break;
                case 'Alignment.bottomRight':
                  _alignment = Alignment.bottomRight;
                  break;
                default:
                  break;
              }
            });
          },
        );
      },
    ));

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Banner example'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String key) {
              setState(() {
                _selection = sizeTypes[key];
                _bannerAd =
                    bannerAdList[sizeTypes.values.toList().indexOf(_selection)];
              });
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
    print('spotId selection : $_selection');
    switch (_selection) {
      case BannerSize.type728x90:
        return (Platform.isAndroid ? 71002 : 70999);
      case BannerSize.type320x100:
        return (Platform.isAndroid ? 71000 : 70996);
      case BannerSize.type300x100:
        return (Platform.isAndroid ? 71001 : 70998);
      case BannerSize.type300x250:
        return (Platform.isAndroid ? 70357 : 70356);
      case BannerSize.type320x50:
      default:
        return (Platform.isAndroid ? 3174 : 3172);
    }
  }

  String get apiKey {
    print('apiKey selection : $_selection');
    switch (_selection) {
      case BannerSize.type728x90:
        return (Platform.isAndroid
            ? "02e6e186bf0183105fba7ce310dafe68ac83fb1c"
            : "2e0b9e0b3f40d952e6000f1a8c4d455fffc4ca3a");
      case BannerSize.type320x100:
        return (Platform.isAndroid
            ? "8932b68d22d1d32f5d7251f9897a6aa64117995e"
            : "eb5ca11fa8e46315c2df1b8e283149049e8d235e");
      case BannerSize.type300x100:
        return (Platform.isAndroid
            ? "1e36d1183d1ab66539998df4170a591c13028416"
            : "25eb32adddc4f7311c3ec7b28eac3b72bbca5656");
      case BannerSize.type300x250:
        return (Platform.isAndroid
            ? "499f011dbec5d37cfa388b749aed2bfff440a794"
            : "88d88a288fdea5c01d17ea8e494168e834860fd6");
      case BannerSize.type320x50:
      default:
        return (Platform.isAndroid
            ? "c5cb8bc474345961c6e7a9778c947957ed8e1e4f"
            : "a6eca9dd074372c898dd1df549301f277c53f2b9");
    }
  }
}
