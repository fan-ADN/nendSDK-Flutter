import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'dart:io' show Platform;

const String _tag = 'Video';

void main() {
  group('executing video test', () {
    FlutterDriver driver;

    setUpAll(() async {
      // Connects to the app
      driver = await FlutterDriver.connect();
      SerializableFinder video = find.byValueKey('Video');
      await driver.tap(video);
      await Future<void>.delayed(Duration(seconds: 1));
    });

    tearDownAll(() async {
      if (driver != null) {
        // Closes the connection
        driver.close();
      }
    });

    test('Interstitial load then release test', () async {
      await Future<void>.delayed(Duration(seconds: 1));
      SerializableFinder interstitialState = find.byValueKey('Interstitial');

      SerializableFinder load = find.byValueKey('Load Interstitial');
      await driver.tap(load);
      await Future<void>.delayed(Duration(seconds: 10));

      String stateText = await driver.getText(interstitialState);
      expect(stateText.contains('onLoaded'), true);
      expect(stateText.contains('Fallback'), false);
      SerializableFinder release = find.byValueKey('Release Interstitial');
      driver.tap(release);

      expect((await driver.getText(interstitialState)).contains(_tag), true);
    });

    test('Interstitial fallback test', () async {
      await Future<void>.delayed(Duration(seconds: 1));
      SerializableFinder fallbackState = find.byValueKey('Fallback');

      SerializableFinder load = find.byValueKey('Load Fallback');
      await driver.tap(load);
      await Future<void>.delayed(Duration(seconds: 10));

      String stateText = await driver.getText(fallbackState);
      expect(stateText.contains('onLoaded'), true);
      expect(stateText.contains('Fallback'), true);
      SerializableFinder release = find.byValueKey('Release Fallback');
      await driver.tap(release);

      expect((await driver.getText(fallbackState)).contains(_tag), true);
    });

    test('Reward all test', () async {
      await Future<void>.delayed(Duration(seconds: 1));
      SerializableFinder state = find.byValueKey('Reward');

      SerializableFinder load = find.byValueKey('Load Reward');
      await driver.tap(load);
      await Future<void>.delayed(Duration(seconds: 10));

      String stateText = await driver.getText(state);
      expect(stateText.contains('onLoaded'), true);
      SerializableFinder showAd = find.byValueKey('Show Ad');
      await driver.tap(showAd);

      if (Platform.isAndroid == true) {
        expect((await driver.getText(state)).contains('onShown'), true);
        await Future<void>.delayed(Duration(seconds: 20));
        expect((await driver.getText(state)).contains('onRewarded'), true);
      } else {
        // Skip the test. (It's not working on iOS environment.)
      }
    }, timeout: Timeout(Duration(seconds: 200)));
  });
}
