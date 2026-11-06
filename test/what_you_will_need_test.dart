import 'package:bonfire_crash_course/presentation/pages/1_introduction/_introduction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpPage(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // The real Lottie loads from the network, which tests can't reach.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(32),
            child: WhatYouWillNeed(
              setupAnimation: SizedBox(height: 150, width: 150),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('three must-have tiles, two chips, three checks, one tip', (
    tester,
  ) async {
    // Roughly the content area of a 1280x800 laptop window, beside the
    // sidebar.
    await pumpPage(tester, const Size(1000, 800));

    final tiles = tester.widgetList<NeedTile>(find.byType(NeedTile)).toList();
    expect(tiles.map((t) => t.title), [
      'A free GitHub account',
      'A web browser',
      'An internet connection',
    ]);
    for (final tile in tiles) {
      expect(
        tile.line.split(' ').length,
        lessThanOrEqualTo(6),
        reason: tile.line,
      );
    }
    expect(find.byType(NiceToHaveChip), findsNWidgets(2));
    expect(find.text('NICE TO HAVE'), findsOneWidget);
    expect(find.byType(ZeroSetupCard), findsOneWidget);
    for (final check in WhatYouWillNeed.setupChecks) {
      expect(find.text(check), findsOneWidget);
    }
    expect(
      find.text('Next up: create your free GitHub account.'),
      findsOneWidget,
    );

    // The old paragraphs (and the OPITIONAL typo) are gone.
    expect(find.textContaining('OPITIONAL'), findsNothing);
    expect(find.textContaining('Say goodbye'), findsNothing);

    // Fits without scrolling on a laptop screen.
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(scroll.position.maxScrollExtent, 0);
  });

  testWidgets('stacks without overflowing on a narrow window', (tester) async {
    await pumpPage(tester, const Size(480, 900));

    expect(tester.takeException(), isNull);
    expect(find.byType(NeedTile), findsNWidgets(3));
    final first = tester.getTopLeft(find.byType(NeedTile).at(0));
    final second = tester.getTopLeft(find.byType(NeedTile).at(1));
    expect(second.dy, greaterThan(first.dy));
  });

  testWidgets('tiles appear at once when reduced motion is on', (tester) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: WhatYouWillNeed(setupAnimation: SizedBox(height: 150)),
          ),
        ),
      ),
    );
    await tester.pump();

    final opacities = tester
        .widgetList<Opacity>(
          find.descendant(
            of: find.byType(NeedTile),
            matching: find.byType(Opacity),
          ),
        )
        .map((o) => o.opacity);
    expect(opacities, everyElement(1.0));
  });
}
