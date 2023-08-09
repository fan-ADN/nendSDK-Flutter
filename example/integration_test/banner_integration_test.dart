import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nend_plugin/nend_plugin.dart';
import 'package:nend_plugin_example/banner.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Banner ad tests', () {
    testWidgets('320x50 banner ad test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      var banner = find.text('loadAd: 320x50');
      await tester.tap(banner);
      await tester.pump(new Duration(seconds: 3));

      var playIcon = find.byIcon(Icons.play_arrow).at(1);
      await tester.tap(playIcon);
      await tester.pumpAndSettle();

      final bannerAd =
          find.byType(BannerAd).first.evaluate().single.widget as BannerAd;
      expect(bannerAd.adjustSize, false);
      expect(bannerAd.bannerSize, BannerSize.type320x50);

      final loadCounter = find.text("onLoaded: 2");
      expect(loadCounter, findsOneWidget);
      final receiveCounter = find.text("onReceived: 2");
      expect(receiveCounter, findsOneWidget);

      /// Default interval for auto reload is 60 sec.
      await tester.pump(new Duration(seconds: 30));
      final receiveIncrementCounter = find.text("onReceived: 3");
      expect(receiveIncrementCounter, findsOneWidget);
    });

    testWidgets('320x100 banner ad test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      var banner = find.text('loadAd: 320x100');
      await tester.tap(banner);
      await tester.pump(new Duration(seconds: 3));

      var playIcon = find.byIcon(Icons.play_arrow).at(1);
      await tester.tap(playIcon);
      await tester.pumpAndSettle();

      final bannerAd =
          find.byType(BannerAd).first.evaluate().single.widget as BannerAd;
      expect(bannerAd.adjustSize, false);
      expect(bannerAd.bannerSize, BannerSize.type320x100);

      final loadCounter = find.text("onLoaded: 2");
      expect(loadCounter, findsOneWidget);
      final receiveCounter = find.text("onReceived: 2");
      expect(receiveCounter, findsOneWidget);
    });

    testWidgets('300x100 banner ad test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      var banner = find.text('loadAd: 300x100');
      await tester.tap(banner);
      await tester.pump(new Duration(seconds: 3));

      var playIcon = find.byIcon(Icons.play_arrow).at(1);
      await tester.tap(playIcon);
      await tester.pumpAndSettle();

      final bannerAd =
          find.byType(BannerAd).first.evaluate().single.widget as BannerAd;
      expect(bannerAd.adjustSize, false);
      expect(bannerAd.bannerSize, BannerSize.type300x100);

      final loadCounter = find.text("onLoaded: 2");
      expect(loadCounter, findsOneWidget);
      final receiveCounter = find.text("onReceived: 2");
      expect(receiveCounter, findsOneWidget);
    });

    testWidgets('300x250 banner ad test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      var banner = find.text('loadAd: 300x250');
      await tester.tap(banner);
      await tester.pump(new Duration(seconds: 3));

      var playIcon = find.byIcon(Icons.play_arrow).at(1);
      await tester.tap(playIcon);
      await tester.pumpAndSettle();

      final bannerAd =
          find.byType(BannerAd).first.evaluate().single.widget as BannerAd;
      expect(bannerAd.adjustSize, false);
      expect(bannerAd.bannerSize, BannerSize.type300x250);

      final loadCounter = find.text("onLoaded: 2");
      expect(loadCounter, findsOneWidget);
      final receiveCounter = find.text("onReceived: 2");
      expect(receiveCounter, findsOneWidget);
    });

    testWidgets('728x90 banner ad test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      var banner = find.text('loadAd: 728x90');
      await tester.tap(banner);
      await tester.pump(new Duration(seconds: 3));

      var playIcon = find.byIcon(Icons.play_arrow).at(1);
      await tester.tap(playIcon);

      await tester.pumpAndSettle();
      final bannerAd =
          find.byType(BannerAd).first.evaluate().single.widget as BannerAd;
      expect(bannerAd.adjustSize, false);
      expect(bannerAd.bannerSize, BannerSize.type728x90);

      /// Assuming that the testing device is NOT tablet.
      final failedToLoadCounter = find.text("onFailedToLoad: 2");
      expect(failedToLoadCounter, findsOneWidget);
    });
  });
}
