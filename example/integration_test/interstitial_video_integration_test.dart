import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nend_plugin_example/interstitial_video.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Interstitial video ad tests', () {
    testWidgets('Show interstitial video ad', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      var loadInterstitialVideo = find.textContaining('Load').first;
      await tester.tap(loadInterstitialVideo);
      await tester.pump(new Duration(seconds: 10));

      final loadCounter = find.text("onLoaded: 1");
      expect(loadCounter, findsOneWidget);

      var showInterstitialVideo = find.textContaining('Show').first;
      await tester.tap(showInterstitialVideo);
      await tester.pump(new Duration(seconds: 10));
    });
  });
}
