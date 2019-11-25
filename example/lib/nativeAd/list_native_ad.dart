import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:nend_plugin/native.dart';

class NativeAdListSample extends StatefulWidget {
  final String _title = 'List example';

  @override
  _NativeAdListSampleState createState() =>
      _NativeAdListSampleState(title: _title);
}

class _NativeAdListSampleState extends State<NativeAdListSample>
    with WidgetsBindingObserver {
  final String title;
  final int listNum = 100;
  NativeAdLoader _loader;
  NativeAd _nativeAd;

  _NativeAdListSampleState({Key key, this.title});

  int get spotId {
    return (Platform.isAndroid ? 485516 : 485500);
  }

  String get apiKey {
    return (Platform.isAndroid
        ? "16cb170982088d81712e63087061378c71e8aa5c"
        : "10d9088b5bd36cf43b295b0774e5dcf7d20a4071");
  }

  Future<void> _refresh() async {
    _loader.loadAd();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _loader = new NativeAdLoader(spotId, apiKey, (NativeAdLoaderEvent event,
        {int errorCode, NativeAd ad}) {
      if (event == NativeAdLoaderEvent.onFailedToLoad) {
        print('NativeAd ' + event.toString() + ' errorCode: $errorCode');
      } else {
        _nativeAd = ad;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _loader.releaseLoader();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _getAdData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return _createListView(context, snapshot);
        }
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: futureBuilder,
    );
  }

  Future<NativeAd> _getAdData() async {
    _nativeAd = null;
    _loader.loadAd();
    while (_nativeAd == null) {
      await new Future.delayed(new Duration(seconds: 1));
    }
    return _nativeAd;
  }

  Stream<NativeAd> _streamNativeAd() async* {
    yield _nativeAd;
  }

  Widget _getRow(int index) {
    final isAdRow = index % 10 == 0 && index > 0;
    Row row = Row(
      children: <Widget>[
        Image.network(
          (isAdRow
              ? _nativeAd.adImageUrl
              : 'https://4.bp.blogspot.com/-f7o29_sqb7Y/Wo8VPH5g14I/AAAAAAAAIOw/yxksrWuXD6Qxk9auMKruANWRpBvE09gmwCLcBGAs/s320/dart2.jpg'),
          width: 100,
          height: 100,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  (isAdRow ? _nativeAd.titleText : 'リスト : $index'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              (isAdRow
                  ? _nativeAd.getAdvertisingExplicitlyWidget(
                      AdvertisingExplicitly.AD,
                      style: TextStyle(fontSize: 12.0, color: Colors.red))
                  : Container(
                      child: Text(
                        'Listサンプル',
                        style: TextStyle(fontSize: 12.0, color: Colors.blue),
                      ),
                    ))
            ],
          ),
        ),
      ],
    );
    return Card(
      child: (isAdRow
          ? NativeAdBinder(_streamNativeAd().asBroadcastStream(), row)
          : GestureDetector(
              child: new Card(
                child: row,
              ),
            )),
    );
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    return new RefreshIndicator(
      child: ListView.builder(
        itemCount: listNum,
        itemBuilder: (BuildContext context, int index) {
          return _getRow(index);
        },
      ),
      onRefresh: _refresh,
    );
  }
}
