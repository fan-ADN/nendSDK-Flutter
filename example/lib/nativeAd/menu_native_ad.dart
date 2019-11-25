import 'package:flutter/material.dart';
import 'simple_native_ad.dart';
import 'list_native_ad.dart';
import 'positioned_stack_native_ad.dart';

const _menu = ['Simple', 'List', 'Positioned'];

class MenuNativeAd extends StatefulWidget {
  @override
  _MenuNativeAdState createState() => new _MenuNativeAdState();
}

class _MenuNativeAdState extends State<MenuNativeAd> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Native Ad'),
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
                      settings: const RouteSettings(name: "/nativeAds"),
                      builder: (BuildContext context) {
                        switch (_menu[index]) {
                          case 'Simple':
                            return NativeAdSimpleSample();
                          case 'List':
                            return NativeAdListSample();
                          case 'Positioned':
                            return NativeAdPositionatedStackSample();
                          default:
                            return null;
                        }
                      }));
            },
          );
        },
      ),
    );
  }
}
