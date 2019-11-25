import 'dart:io';

import 'package:flutter/material.dart';

import 'package:nend_plugin/interstitial.dart';
import 'main.dart';

const menu = [
  'Load',
  'Load2',
  'Show',
  'Show with spotID',
  'Show with spotID2',
  'Dismiss',
  'AutoReload enabled',
  'AutoReload disabled',
  'Set Listenr1',
  'Set Listenr2',
];

class Interstitial extends StatefulWidget {
  @override
  _InterstitialState createState() => new _InterstitialState();
}

class _InterstitialState extends State<Interstitial> {
  String _interstitialState = 'Interstitial';
  InterstitialAd _interstitial;

  int get spotId => (Platform.isAndroid ? 213206 : 213208);
  String get apiKey => (Platform.isAndroid
      ? "8c278673ac6f676dae60a1f56d16dad122e23516"
      : "308c2499c75c4a192f03c02b2fcebd16dcb45cc9");

  int get spotId2 => (Platform.isAndroid ? 213206 : 213208);
  String get apiKey2 => (Platform.isAndroid
      ? "8c278673ac6f676dae60a1f56d16dad122e23516"
      : "308c2499c75c4a192f03c02b2fcebd16dcb45cc9");

  @override
  void initState() {
    super.initState();
    _interstitial = InterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List<Widget>();

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
                case 'Load':
                  _interstitial.load(spotId, apiKey);
                  break;
                case 'Load2':
                  _interstitial.load(spotId2, apiKey2);
                  break;
                case 'Show':
                  _interstitial.show();
                  break;
                case 'Show with spotID':
                  _interstitial.show(spotId);
                  break;
                case 'Show with spotID2':
                  _interstitial.show(spotId2);
                  break;
                case 'Dismiss':
                  dismiss();
                  break;
                case 'AutoReload enabled':
                  _interstitial.enableAutoReload = true;
                  break;
                case 'AutoReload disabled':
                  _interstitial.enableAutoReload = false;
                  break;
                case 'Set Listenr1':
                  print('Set Listener1');
                  _interstitial.listener =
                      ((InterstitialAdEvent event, int spotId,
                          {int errorCode}) {
                    setState(() {
                      if (errorCode == null) {
                        print('Listener1 ' +
                            event.toString() +
                            ' SpotID = ' +
                            spotId.toString());
                      } else {
                        print('Listener1 ' +
                            event.toString() +
                            ' SpotID = ' +
                            spotId.toString() +
                            " error :" +
                            errorCode.toString());
                      }
                      _interstitialState = event.toString();
                    });
                  });
                  break;
                case 'Set Listenr2':
                  print('Set Listener2');
                  _interstitial.listener =
                      ((InterstitialAdEvent event, int spotId,
                          {int errorCode}) {
                    setState(() {
                      if (errorCode == null) {
                        print('Listener2 ' +
                            event.toString() +
                            ' SpotID = ' +
                            spotId.toString());
                      } else {
                        print('Listener2 ' +
                            event.toString() +
                            ' SpotID = ' +
                            spotId.toString() +
                            " error :" +
                            errorCode.toString());
                      }
                      _interstitialState = event.toString();
                    });
                  });
                  break;
                default:
                  break;
              }
            });
          },
        );
      },
    ));

    children.add(new StateDisplay(
      title: 'StateDisplay',
      state: _interstitialState,
      color: Colors.black,
    ));

    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Interstitial example'),
        ),
        body: SafeArea(
          child: new Stack(
            alignment: Alignment.bottomCenter,
            children: children,
          ),
        ));
  }

  void dismiss() async {
    await new Future.delayed(
        const Duration(seconds: 5), () => _interstitial.dismiss());
  }
}
