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
      SerializableFinder simple = find.byValueKey('Positioned');
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

    test('Viewable test', () async {
      await driver.tap(find.byValueKey('PopupMenuButton'));
      await driver.tap(find.byValueKey('Bottom Left'));
      await Future<void>.delayed(Duration(seconds: 3));

      SerializableFinder loaderState =
          await find.byValueKey('LoaderStateDisplay');
      expect(
          (await driver.getText(loaderState)).contains('onImpression'), false);

      await driver.tap(find.byValueKey('PopupMenuButton'));
      await driver.tap(find.byValueKey('Top Right'));
      await Future<void>.delayed(Duration(seconds: 3));
      //loaderState = await find.byValueKey('LoaderStateDisplay');
      expect(
          (await driver.getText(loaderState)).contains('onImpression'), false);

      await driver.tap(find.byValueKey('PopupMenuButton'));
      await driver.tap(find.byValueKey('Top Left'));
      await Future<void>.delayed(Duration(seconds: 3));
      //loaderState = await find.byValueKey('LoaderStateDisplay');
      expect(
          (await driver.getText(loaderState)).contains('onImpression'), false);

      await driver.tap(find.byValueKey('PopupMenuButton'));
      await driver.tap(find.byValueKey('x position to 0.0'));
      await Future<void>.delayed(Duration(seconds: 1));
      await driver.tap(find.byValueKey('PopupMenuButton'));
      await driver.tap(find.byValueKey('y position to 0.0'));
      await Future<void>.delayed(Duration(seconds: 3));
      SerializableFinder state = await find.byValueKey('StateDisplay');
      expect((await driver.getText(state)).contains('onImpression'), true);
    });

    test('Invalid binder test', () async {
      await driver.tap(find.byValueKey('PopupMenuButton'));
      await driver.tap(find.byValueKey('Reload'));
      await Future<void>.delayed(Duration(seconds: 3));

      await driver.tap(find.byValueKey('Invalid binder'));
      SerializableFinder state = await find.byValueKey('StateDisplay');
      expect((await driver.getText(state)).contains('onClickAd'), false);
    });
  });
}
