import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('executing interstitial test', () {
    FlutterDriver driver;

    setUpAll(() async {
      // Connects to the app
      driver = await FlutterDriver.connect();
      SerializableFinder interstitial = find.byValueKey('Interstitial');
      await driver.tap(interstitial);
      await Future<void>.delayed(Duration(seconds: 1));
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Interstitial load and show test', () async {
      await Future<void>.delayed(Duration(seconds: 1));

      await driver.tap(find.byValueKey('Set Listenr1'));
      await driver.tap(find.byValueKey('Load'));

      SerializableFinder state = find.byValueKey('StateDisplay');
      await Future<void>.delayed(Duration(seconds: 5));

      expect((await driver.getText(state)).contains('onLoaded'), true);

      await driver.tap(find.byValueKey('Dismiss'));
      await driver.tap(find.byValueKey('Show'));
//      expect((await driver.getText(state)).contains('OnShown'), true);
//      await Future<void>.delayed(Duration(seconds: 7));
//      expect((await driver.getText(state)).contains('onClosed'), true);

      await Future<void>.delayed(Duration(seconds: 1));

      await driver.tap(find.byValueKey('Load2'));

      await Future<void>.delayed(Duration(seconds: 2));

      expect((await driver.getText(state)).contains('onLoaded'), true);
      await driver.tap(find.byValueKey('Set Listenr2'));
      await driver.tap(find.byValueKey('AutoReload disabled'));
      await driver.tap(find.byValueKey('Dismiss'));
      await driver.tap(find.byValueKey('Show with spotID2'));
      await Future<void>.delayed(Duration(seconds: 7));
      expect((await driver.getText(state)).contains('onClosed'), true);
    });
  });
}
