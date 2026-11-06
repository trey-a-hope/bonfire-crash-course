import 'package:bonfire_crash_course/presentation/pages/3_map/map_module.dart';
import 'package:bonfire_crash_course/presentation/pages/module_completion_page.dart';
import 'package:bonfire_crash_course/presentation/rive/getting_started/getting_started_rive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The native Rive runtime isn't available under `flutter test`.
  setUp(() => GettingStartedRive.loadFile = (_) async => null);

  testWidgets('the trophy animation sits at the top of the page', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // The "Up next" banner loads a Lottie from the network, which tests can't
    // reach; its failed load (and the error box that overflows the banner)
    // has nothing to do with the trophy, so only those errors are ignored.
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      final text = details.toString();
      if (text.contains('overflowed') || text.contains('HTTP')) return;
      original?.call(details);
    };
    addTearDown(() => FlutterError.onError = original);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ModuleCompletionPage(module: MAP_MODULE)),
      ),
    );
    await tester.pump();
    await tester.pump();

    final trophy = find.byType(GettingStartedRive);
    expect(trophy, findsOneWidget);
    expect(
      tester.widget<GettingStartedRive>(trophy).scene,
      GettingStartedScene.moduleComplete,
    );
    // Above the headline.
    expect(
      tester.getRect(trophy).bottom,
      lessThan(tester.getTopLeft(find.text(MAP_MODULE.completionHeadline)).dy),
    );
    // A file that can't load shows a trophy icon instead.
    expect(
      find.byKey(const ValueKey('getting-started-rive-fallback')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(GettingStartedScene.moduleComplete.semanticLabel),
      findsOneWidget,
    );
  });
}
