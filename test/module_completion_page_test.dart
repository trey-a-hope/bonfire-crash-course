import 'package:bonfire_crash_course/presentation/pages/2_getting_started/getting_started_module.dart';
import 'package:bonfire_crash_course/presentation/pages/3_map/map_module.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/player_module.dart';
import 'package:bonfire_crash_course/presentation/pages/6_npc/npc_module.dart';
import 'package:bonfire_crash_course/presentation/pages/7_final/bonfire_crash_course_module.dart';
import 'package:bonfire_crash_course/presentation/pages/module_completion_page.dart';
import 'package:bonfire_crash_course/presentation/rive/getting_started/getting_started_rive.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/_cards.dart';
import 'package:material_ui/material_ui.dart';
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

  Future<void> pumpCompletion(
    WidgetTester tester,
    Widget page, {
    Size size = const Size(1440, 1000),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // The "Up next" Lottie loads from the network, which tests can't reach,
    // and its error box overflows the banner; only those errors are ignored.
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      final text = details.toString();
      if (text.contains('overflowed') || text.contains('HTTP')) return;
      original?.call(details);
    };
    addTearDown(() => FlutterError.onError = original);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: page)));
    await tester.pump();
    await tester.pump();
  }

  testWidgets('Getting Started shows its three recap cards', (tester) async {
    await pumpCompletion(
      tester,
      const ModuleCompletionPage(module: GETTING_STARTED_MODULE),
    );

    final titles = tester
        .widgetList<MetricCard>(find.byType(MetricCard))
        .map((card) => card.title)
        .toList();
    expect(titles, [
      'GitHub account ready',
      'Codespace set up',
      'Starter game running',
    ]);
    expect(find.textContaining('save your free hours'), findsOneWidget);
    expect(find.textContaining('Press r in the terminal'), findsOneWidget);

    // The old placeholder cards are gone.
    expect(find.text('100% Complete'), findsNothing);
    expect(find.text('Milestone Achieved'), findsNothing);
    expect(find.text('Live in Game'), findsNothing);

    // Three to a row on a wide window.
    final tops = titles.map((t) => tester.getTopLeft(find.text(t)).dy).toSet();
    expect(tops, hasLength(1));
  });

  testWidgets('every module shows its own three recap cards', (tester) async {
    await pumpCompletion(
      tester,
      const ModuleCompletionPage(module: PLAYER_MODULE),
    );

    expect(find.byType(MetricCard), findsNWidgets(3));
    for (final item in PLAYER_MODULE.achievements) {
      expect(find.text(item.title), findsOneWidget);
    }
  });

  test('every finish page has exactly three recap points', () {
    for (final module in const [
      GETTING_STARTED_MODULE,
      MAP_MODULE,
      PLAYER_MODULE,
      NPC_MODULE,
      BONFIRE_CRASH_COURSE,
    ]) {
      expect(module.achievements, hasLength(3), reason: module.moduleName);
    }
  });

  testWidgets('recap cards wrap to one column on a narrow window', (
    tester,
  ) async {
    await pumpCompletion(
      tester,
      const ModuleCompletionPage(module: GETTING_STARTED_MODULE),
      size: const Size(480, 1400),
    );

    final cards = find.byType(MetricCard);
    final lefts = List.generate(
      cards.evaluate().length,
      (i) => tester.getTopLeft(cards.at(i)).dx,
    ).toSet();
    expect(lefts, hasLength(1));
    // Each card fits the window, so its text wraps instead of running off.
    for (var i = 0; i < cards.evaluate().length; i++) {
      expect(tester.getRect(cards.at(i)).right, lessThanOrEqualTo(480));
    }
  });
}
