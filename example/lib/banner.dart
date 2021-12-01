import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:nend_plugin/nend_plugin.dart';

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

class BannerSample extends StatefulWidget {
  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<BannerSample> {
  late BannerAdController adController;
  late BannerAdController adjustAdController;
  BannerSize bannerSize = BannerSize.type320x50;
  bool isLoaded = false;

  @override
  void dispose() {
    super.dispose();
    adController.dispose();
    adjustAdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Banner Sample'),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Text('Banner'),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () => adController.show(),
                  ),
                  IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () => adController.hide(),
                  ),
                  TextButton(
                    onPressed: () => adController.resume(),
                    child: Text('RESUME'),
                  ),
                  TextButton(
                    onPressed: () => adController.pause(),
                    child: Text('PAUSE'),
                  )
                ],
              ),
              Text('Adjust Size Banner'),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () => adjustAdController.show(),
                  ),
                  IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () => adjustAdController.hide(),
                  ),
                  TextButton(
                    onPressed: () => adjustAdController.resume(),
                    child: Text('RESUME'),
                  ),
                  TextButton(
                    onPressed: () => adjustAdController.pause(),
                    child: Text('PAUSE'),
                  )
                ],
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () => loadAd(size: BannerSize.type320x50),
                    child: Text('loadAd: 320x50'),
                  ),
                  TextButton(
                    onPressed: () => loadAd(size: BannerSize.type320x100),
                    child: Text('loadAd: 320x100'),
                  ),
                  TextButton(
                    onPressed: () => loadAd(size: BannerSize.type300x100),
                    child: Text('loadAd: 300x100'),
                  ),
                  TextButton(
                    onPressed: () => loadAd(size: BannerSize.type300x250),
                    child: Text('loadAd: 300x250'),
                  ),
                  TextButton(
                    onPressed: () => loadAd(size: BannerSize.type728x90),
                    child: Text('loadAd: 728x90'),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BannerAd(
                    bannerSize: bannerSize,
                    listener: _eventListener(),
                    onCreated: (controller) {
                      adController = controller;
                      adController.load(spotId: spotId, apiKey: apiKey);
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  BannerAd(
                    bannerSize: bannerSize,
                    listener: _eventListener(),
                    adjustSize: true,
                    onCreated: (controller) {
                      adjustAdController = controller;
                      adjustAdController.load(
                        spotId: spotId,
                        apiKey: apiKey,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ));
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

  void loadAd({required BannerSize size}) {
    bannerSize = size;
    setState(() {
      adController.load(spotId: spotId, apiKey: apiKey);
      adjustAdController.load(
        spotId: spotId,
        apiKey: apiKey,
      );
    });
  }

  int get spotId {
    switch (bannerSize) {
      case BannerSize.type728x90:
        return Platform.isAndroid ? 71002 : 70999;
      case BannerSize.type320x100:
        return Platform.isAndroid ? 71000 : 70996;
      case BannerSize.type300x100:
        return Platform.isAndroid ? 71001 : 70998;
      case BannerSize.type300x250:
        return Platform.isAndroid ? 70357 : 70356;
      case BannerSize.type320x50:
      default:
        return Platform.isAndroid ? 3174 : 3172;
    }
  }

  String get apiKey {
    switch (bannerSize) {
      case BannerSize.type728x90:
        return Platform.isAndroid
            ? '02e6e186bf0183105fba7ce310dafe68ac83fb1c'
            : '2e0b9e0b3f40d952e6000f1a8c4d455fffc4ca3a';
      case BannerSize.type320x100:
        return Platform.isAndroid
            ? '8932b68d22d1d32f5d7251f9897a6aa64117995e'
            : 'eb5ca11fa8e46315c2df1b8e283149049e8d235e';
      case BannerSize.type300x100:
        return Platform.isAndroid
            ? '1e36d1183d1ab66539998df4170a591c13028416'
            : '25eb32adddc4f7311c3ec7b28eac3b72bbca5656';
      case BannerSize.type300x250:
        return Platform.isAndroid
            ? '499f011dbec5d37cfa388b749aed2bfff440a794'
            : '88d88a288fdea5c01d17ea8e494168e834860fd6';
      case BannerSize.type320x50:
      default:
        return Platform.isAndroid
            ? 'c5cb8bc474345961c6e7a9778c947957ed8e1e4f'
            : 'a6eca9dd074372c898dd1df549301f277c53f2b9';
    }
  }
}
