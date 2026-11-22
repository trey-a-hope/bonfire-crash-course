import 'package:bonfire_crash_course/presentation/pages/content_outline_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

/// The Map module's outline page, as the Content Outline pane lists it.
const _page = ContentOutlinePage(
  moduleNumber: 3,
  moduleName: 'Map',
  tagline: 'Build the game world',
  icon: Icons.map,
  accentColor: Colors.deepOrangeAccent,
  lessonCount: 3,
  diagramAsset: 'assets/images/module_diagrams/module_3_map.svg',
);

/// Pumps [page] (the Map outline by default) in a window of [size] logical
/// pixels and waits for the SVG to load.
Future<void> _pump(
  WidgetTester tester,
  Size size, {
  ContentOutlinePage page = _page,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: page)));
  await tester.pumpAndSettle();
}

void main() {
  // The copy: pill, heading, intro, diagram and footer.
  testWidgets('shows the outline header, diagram and lesson count', (
    tester,
  ) async {
    await _pump(tester, const Size(1280, 900));

    expect(find.text('CONTENT OUTLINE • MODULE 3'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
    expect(
      find.text(
        "Build the game world. Here's a look back at everything this module covered.",
      ),
      findsOneWidget,
    );
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(
      find.text(
        "3 lessons in this module. Use the sidebar to review another module's outline.",
      ),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel(RegExp('Map module diagram')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses the singular for a one-lesson module', (tester) async {
    await _pump(
      tester,
      const Size(1280, 900),
      page: const ContentOutlinePage(
        moduleNumber: 3,
        moduleName: 'Map',
        tagline: 'Build the game world',
        icon: Icons.map,
        accentColor: Colors.deepOrangeAccent,
        lessonCount: 1,
        diagramAsset: 'assets/images/module_diagrams/module_3_map.svg',
      ),
    );

    expect(
      find.text(
        "1 lesson in this module. Use the sidebar to review another module's outline.",
      ),
      findsOneWidget,
    );
  });

  // Layout: no overflow on narrow windows, and the diagram stays full width.
  testWidgets('fits a narrow window without overflowing', (tester) async {
    await _pump(tester, const Size(500, 700));

    expect(tester.takeException(), isNull);
  });

  testWidgets('diagram card spans the full width of the content area', (
    tester,
  ) async {
    for (final width in [500.0, 1280.0, 1920.0]) {
      await _pump(tester, Size(width, 900));

      final card = find.ancestor(
        of: find.byType(SvgPicture),
        matching: find.byType(Container),
      );
      // 24px of page padding on each side, and no cap on the column.
      expect(tester.getSize(card.first).width, width - 48);
      expect(tester.getSize(find.byType(SvgPicture)).width, width - 48 - 2);
      expect(tester.takeException(), isNull);
    }
  });
}
