import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('executing native ad test', () {
    FlutterDriver driver;

    setUpAll(() async {
      // Connects to the app
      driver = await FlutterDriver.connect();
      SerializableFinder menu = find.byValueKey('Native');
      await driver.tap(menu);
      SerializableFinder simple = find.byValueKey('Simple');
      await driver.tap(simple);
      await Future<void>.delayed(Duration(seconds: 1));
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.tap(find.pageBack());
        // Closes the connection
        await driver.close();
      }
    });

    test('Basic load ad test', () async {
      await driver.tap(find.byValueKey('PopupMenuButton'));
      await driver.tap(find.byValueKey('Load'));

      await Future<void>.delayed(Duration(seconds: 3));

      SerializableFinder loaderState =
          await find.byValueKey('LoaderStateDisplay');
      expect((await driver.getText(loaderState)).contains('onLoaded'), true);

      SerializableFinder adState = await find.byValueKey('AdStateDisplay');
      expect((await driver.getText(adState)).contains('onImpression'), true);
    });

    test('Interval load ad test', () async {
      await driver.tap(find.byValueKey('PopupMenuButton'));
      await driver.tap(find.byValueKey('Load with interval 30 sec'));

      await Future<void>.delayed(Duration(seconds: 30));

      SerializableFinder loaderState =
          await find.byValueKey('LoaderStateDisplay');

      var firstState = await driver.getText(loaderState);
      await Future<void>.delayed(Duration(seconds: 30));

      expect((await driver.getText(loaderState)) == firstState, false);

      await driver.tap(find.byValueKey('PopupMenuButton'));
      await driver.tap(find.byValueKey('Set interval to 29 sec'));
      expect((await driver.getText(loaderState)).contains('NativeAd'), true);
    }, timeout: Timeout(Duration(seconds: 200)));
  });
}
