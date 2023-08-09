import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nend_plugin_example/rewarded_video.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Rewarded video ad tests', () {
    testWidgets('Show rewarded video ad', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      var loadRewardedVideo = find.textContaining('Load').first;
      await tester.tap(loadRewardedVideo);
      await tester.pump(new Duration(seconds: 10));

      final loadCounter = find.text("onLoaded: 1");
      expect(loadCounter, findsOneWidget);

      var showRewardedVideo = find.textContaining('Show').first;
      await tester.tap(showRewardedVideo);
      await tester.pump(new Duration(seconds: 10));
    });
  });
}
