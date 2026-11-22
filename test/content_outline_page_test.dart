import 'dart:io';

import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/pages/content_outline/content_outline_page.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/sidebar.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// The first course page, where Back goes when there is nothing to pop.
final _introPath = ProgressNavigationController.navigateablePanes.first.path;

/// A router with a stand-in first lesson that shows the real [Sidebar], and
/// the real Content Outline route, starting at [initialLocation].
GoRouter _router(String initialLocation) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: _introPath,
      builder: (context, state) => Scaffold(
        body: Row(
          children: [
            Sidebar(
              currentIndex: 0,
              progressPercentage: 0,
              progressColor: Colors.blueAccent,
              progressFraction: 0,
              goBranch: (index, {initialLocation = false}) {},
            ),
            const Expanded(child: Text('Intro page')),
          ],
        ),
      ),
    ),
    GoRoute(
      path: ContentOutlinePage.path,
      builder: (context, state) => const ContentOutlinePage(),
    ),
  ],
);

/// Pumps the app at [initialLocation] (the Content Outline by default) in a
/// window of [size] logical pixels and waits for the SVGs to load.
Future<void> _pump(
  WidgetTester tester,
  Size size, {
  String initialLocation = ContentOutlinePage.path,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp.router(routerConfig: _router(initialLocation)),
  );
  await tester.pumpAndSettle();
}

/// A window tall enough for the ListView to build all three sections.
const _tall = Size(1280, 4000);

void main() {
  // The page's copy: header, intro, and one section per module in order.
  group('content', () {
    testWidgets('shows the header and intro', (tester) async {
      await _pump(tester, _tall);

      expect(find.text('Content Outline'), findsOneWidget);
      expect(find.byTooltip('Back'), findsOneWidget);
      expect(find.text(ContentOutlinePage.intro), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows Map, Player and NPC sections in order', (tester) async {
      await _pump(tester, _tall);

      const sections = [
        ('MODULE 3', 'Map', 'Build the game world', 3),
        ('MODULE 4', 'Player', 'Build and control the hero', 6),
        ('MODULE 5', 'NPC (Ally)', 'Add a friendly character', 6),
      ];
      double? previousTop;
      for (final (pill, name, tagline, count) in sections) {
        expect(find.text(pill), findsOneWidget);
        expect(find.text(name), findsOneWidget);
        expect(find.text(tagline), findsOneWidget);
        expect(
          find.bySemanticsLabel(
            RegExp('^${RegExp.escape(name)} module diagram'),
          ),
          findsOneWidget,
        );

        // The section's lesson count line, from its module's totalSteps.
        expect(
          find.text('$count lessons in this module.').evaluate().length,
          greaterThan(0),
        );

        // Each section starts below the one before it.
        final top = tester.getTopLeft(find.text(pill)).dy;
        if (previousTop != null) expect(top, greaterThan(previousTop));
        previousTop = top;
      }
      expect(find.text('3 lessons in this module.'), findsOneWidget);
      expect(find.text('6 lessons in this module.'), findsNWidgets(2));
      expect(find.byType(SvgPicture), findsNWidgets(3));
    });

    test('every diagram asset exists', () {
      for (final asset in [
        'module_3_map.svg',
        'module_4_player.svg',
        'module_5_npc_ally.svg',
      ]) {
        expect(
          File('assets/images/module_diagrams/$asset').existsSync(),
          isTrue,
        );
      }
    });
  });

  // Layout: capped at 1100 wide, diagrams fill it, and narrow windows fit.
  group('layout', () {
    testWidgets('fits a narrow window without overflowing', (tester) async {
      await _pump(tester, const Size(500, 700));

      expect(tester.takeException(), isNull);
    });

    testWidgets('diagram cards span the content width, up to 1100', (
      tester,
    ) async {
      for (final width in [700.0, 1280.0, 1920.0]) {
        await _pump(tester, Size(width, 4000));

        // 32px of padding on each side of the 1100-wide column.
        final content = (width < 1100 ? width : 1100) - 64;
        final card = find.ancestor(
          of: find.byType(SvgPicture).first,
          matching: find.byType(Container),
        );
        expect(tester.getSize(card.first).width, content);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('the whole page scrolls as one list', (tester) async {
      await _pump(tester, const Size(1280, 900));

      expect(find.byType(ListView), findsOneWidget);
      await tester.scrollUntilVisible(find.text('MODULE 5'), 400);
      expect(find.text('MODULE 5'), findsOneWidget);
    });
  });

  // Navigation: the sidebar footer link opens the page, and Back leaves it.
  group('navigation', () {
    testWidgets('sidebar footer lists Content Outline first', (tester) async {
      await _pump(tester, const Size(1280, 900), initialLocation: _introPath);

      final outline = tester.getTopLeft(find.text('Content Outline')).dy;
      final files = tester.getTopLeft(find.text('Starter Project Files')).dy;
      final settings = tester.getTopLeft(find.text('Settings')).dy;
      final progress = tester.getTopLeft(find.text('Progress')).dy;
      expect(outline, lessThan(files));
      expect(files, lessThan(settings));
      expect(settings, lessThan(progress));
    });

    testWidgets('the footer tile opens the page and Back returns', (
      tester,
    ) async {
      await _pump(tester, _tall, initialLocation: _introPath);

      await tester.tap(find.text('Content Outline'));
      await tester.pumpAndSettle();
      expect(find.byType(ContentOutlinePage), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.byType(ContentOutlinePage), findsNothing);
      expect(find.text('Intro page'), findsOneWidget);
    });

    testWidgets('Back goes to the first lesson when nothing can pop', (
      tester,
    ) async {
      await _pump(tester, _tall);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Intro page'), findsOneWidget);
    });
  });
}
