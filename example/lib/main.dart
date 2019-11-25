import 'package:flutter/material.dart';
import 'package:nend_plugin_example/banner.dart';
import 'package:nend_plugin_example/video.dart';
import 'package:nend_plugin_example/interstitial.dart';
import 'package:nend_plugin_example/nativeAd/menu_native_ad.dart';

const _menu = [
  'Banner',
  'Banner(adjust mode)',
  'Interstitial',
  'Native',
//    'Fullboard',
  'Video',
//    'NativeVideo',
];

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new ListView.builder(
          key: Key('menu_list'),
          padding: EdgeInsets.all(8.0),
          itemExtent: 44.0,
          itemCount: _menu.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              key: Key(_menu[index]),
              child: Text(_menu[index]),
              onTapUp: (details) {
                Navigator.push(
                    context,
                    new MaterialPageRoute<Null>(
                        settings: const RouteSettings(name: "/ads"),
                        builder: (BuildContext context) {
                          switch (_menu[index]) {
                            case 'Banner':
                              return new BannerSample();
                            case 'Banner(adjust mode)':
                              return new AdjustBannerSample();
                            case 'Interstitial':
                              return new Interstitial();
                            case 'Native':
                              return new MenuNativeAd();
//                                            case 'Fullboard':
//                                                return new Fullboard();
                            case 'Video':
                              return new Video();
//                                            case 'NativeVideo':
//                                                return new NativeVideo();
                            default:
                              return null;
                          }
                        }));
              },
            );
          },
        ),
      ),
    );
  }
}

class StateDisplay extends StatelessWidget {
  StateDisplay({this.title, this.state, this.color});
  final String state;
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return new Text(
      '$title state: $state',
      key: Key(title),
      style: TextStyle(color: color),
    );
  }
}
