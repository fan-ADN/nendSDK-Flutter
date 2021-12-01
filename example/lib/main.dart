import 'package:flutter/material.dart';
import 'package:nend_plugin_example/ad_logger.dart';
import 'package:nend_plugin_example/banner.dart';
import 'package:nend_plugin_example/interstitial_video.dart';
import 'package:nend_plugin_example/interstitial.dart';
import 'package:nend_plugin_example/rewarded_video.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final _menu = [
    'Banner',
    'Interstitial',
    'Interstitial Video',
    'Rewarded Video',
    'Setting Ad Logger',
  ];

  final _samples = [
    BannerSample(),
    InterstitialSample(),
    InterstitialVideoSample(),
    RewardedVideoSample(),
    SettingAdLogger(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('nend plugin example'),
        ),
        body: ListView.builder(
          itemCount: _menu.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  title: Text(
                    _menu[index],
                    textAlign: TextAlign.left,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => _samples[index],
                    ));
                  },
                ),
                Divider(height: 0),
              ],
            );
          },
        ),
      ),
    );
  }
}

class StateDisplay extends StatelessWidget {
  StateDisplay({this.title, this.state, this.color});
  final String? state;
  final String? title;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      '$title state: $state',
      key: Key(title!),
      style: TextStyle(color: color),
    );
  }
}
