import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'dart:io' show Platform;

void main() {
  group('executing banner test', () {
    FlutterDriver? driver;

    setUpAll(() async {
      // Connects to the app
      driver = await FlutterDriver.connect();
      SerializableFinder banner = find.byValueKey('Banner');
      await driver!.tap(banner);
      await Future<void>.delayed(Duration(seconds: 1));
    });

    tearDownAll(() async {
      if (driver != null) {
        // Closes the connection
        driver!.close();
      }
    });

    test('Basic check ad type test', () async {
      await Future<void>.delayed(Duration(seconds: 1));

      var menu = 'type320x100';
      await driver!.tap(find.byValueKey('PopupMenuButton'));
      await driver!.tap(find.byValueKey(menu));

      await driver!.tap(find.byValueKey('Show'));
      await Future<void>.delayed(Duration(seconds: 2));
      await driver!.tap(find.byValueKey('Hide'));
      await Future<void>.delayed(Duration(seconds: 2));

      menu = 'type300x100';
      await driver!.tap(find.byValueKey('PopupMenuButton'));
      await driver!.tap(find.byValueKey(menu));

      await driver!.tap(find.byValueKey('Show'));
      await Future<void>.delayed(Duration(seconds: 2));
      await driver!.tap(find.byValueKey('Hide'));
      await Future<void>.delayed(Duration(seconds: 2));

      menu = 'type300x250';
      await driver!.tap(find.byValueKey('PopupMenuButton'));
      await driver!.tap(find.byValueKey(menu));

      await driver!.tap(find.byValueKey('Show'));
      await Future<void>.delayed(Duration(seconds: 2));
      await driver!.tap(find.byValueKey('Hide'));
      await Future<void>.delayed(Duration(seconds: 2));

      menu = 'type320x50';
      await driver!.tap(find.byValueKey('PopupMenuButton'));
      await driver!.tap(find.byValueKey(menu));

      await driver!.tap(find.byValueKey('Show'));
      await Future<void>.delayed(Duration(seconds: 2));
      await driver!.tap(find.byValueKey('Hide'));
      await Future<void>.delayed(Duration(seconds: 2));
    });

    test('Check loader is working after hide then re-show test', () async {
      await Future<void>.delayed(Duration(seconds: 1));
      SerializableFinder state = find.byValueKey('StateDisplay');

      SerializableFinder showAd = find.byValueKey('Show');
      await driver!.tap(showAd);
      if (Platform.isAndroid == true) {
        await Future<void>.delayed(Duration(seconds: 3));
      } else {
        await Future<void>.delayed(Duration(seconds: 40));
      }
      expect((await driver!.getText(state)).contains('onLoaded'), true);

      SerializableFinder hideAd = find.byValueKey('Hide');
      await driver!.tap(hideAd);
      await Future<void>.delayed(Duration(seconds: 3));

      await driver!.tap(showAd);
      await Future<void>.delayed(Duration(seconds: 3));

      if (Platform.isAndroid == true) {
        await Future<void>.delayed(Duration(seconds: 3));
      } else {
        await Future<void>.delayed(Duration(seconds: 40));
      }
      expect((await driver!.getText(state)).contains('Hide'), false);
    }, timeout: Timeout(Duration(seconds: 200)));
  });
}
