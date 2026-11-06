import 'package:bonfire_crash_course/presentation/pages/1_introduction/_introduction.dart';
import 'package:bonfire_crash_course/presentation/rive/getting_started/getting_started_rive.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The native Rive runtime isn't available under `flutter test`, so the
  // animation shows its fallback icon.
  setUp(() => GettingStartedRive.loadFile = (_) async => null);

  Future<void> pumpPage(
    WidgetTester tester,
    Size size, {
    bool reduceMotion = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: size, disableAnimations: reduceMotion),
          child: const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(32),
              child: WhatYouWillNeed(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Zero setup animation, tiles, optional line, then tip', (
    tester,
  ) async {
    await pumpPage(tester, const Size(1160, 900));

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
    expect(find.text('OPTIONAL'), findsOneWidget);
    expect(find.byType(OptionalChip), findsNWidgets(2));
    expect(
      find.text('Next up: create your free GitHub account.'),
      findsOneWidget,
    );
    // The page plays the Zero setup Rive animation.
    final rive = tester.widget<GettingStartedRive>(
      find.byType(GettingStartedRive),
    );
    expect(rive.scene, GettingStartedScene.zeroSetup);

    // Top to bottom: tiles, optional line, tip.
    final tilesY = tester.getTopLeft(find.byType(NeedTile).first).dy;
    final optionalY = tester.getTopLeft(find.text('OPTIONAL')).dy;
    final tipY = tester.getTopLeft(find.byType(OneLineTip)).dy;
    expect(tilesY, lessThan(optionalY));
    expect(optionalY, lessThan(tipY));

    expect(find.textContaining('OPITIONAL'), findsNothing);
    expect(find.textContaining('Say goodbye'), findsNothing);
  });

  for (final size in const [
    Size(1600, 1000),
    Size(1160, 900),
    Size(640, 900),
  ]) {
    testWidgets('same layout at ${size.width.toInt()} px wide', (tester) async {
      await pumpPage(tester, size);

      expect(tester.takeException(), isNull);
      // The three tiles always sit side by side, on one row.
      final ys = [
        for (var i = 0; i < 3; i++)
          tester.getTopLeft(find.byType(NeedTile).at(i)).dy,
      ];
      expect(ys.toSet(), hasLength(1));
    });
  }

  testWidgets('tiles appear at once when reduced motion is on', (tester) async {
    await pumpPage(tester, const Size(1160, 900), reduceMotion: true);
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
