import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nend_plugin_example/interstitial.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Interstitial ad tests', () {
    testWidgets('Show interstitial ad 1', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      var loadInterstitial1 = find.textContaining('Load').first;
      await tester.tap(loadInterstitial1);
      await tester.pump(new Duration(seconds: 3));

      final loadCounter = find.text("onLoaded: 1");
      expect(loadCounter, findsOneWidget);

      var showInterstitial1 = find.textContaining('Show').first;
      await tester.tap(showInterstitial1);
      await tester.pumpAndSettle();

      final showCounter = find.text("onShown: 1");
      expect(showCounter, findsOneWidget);
    });

    testWidgets('Show interstitial ad 2', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      var loadInterstitial2 = find.textContaining('Load').at(1);
      await tester.tap(loadInterstitial2);
      await tester.pump(new Duration(seconds: 3));

      final loadCounter = find.text("onLoaded: 1");
      expect(loadCounter, findsOneWidget);

      var showInterstitial2 = find.textContaining('Show').at(1);
      await tester.tap(showInterstitial2);
      await tester.pumpAndSettle();

      final showCounter = find.text("onShown: 1");
      expect(showCounter, findsOneWidget);
    });
  });
}
