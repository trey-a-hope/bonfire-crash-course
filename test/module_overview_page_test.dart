import 'package:bonfire_crash_course/presentation/pages/module_overview_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

const _page = ModuleOverviewPage(
  moduleNumber: 3,
  moduleName: 'Map',
  tagline: 'Build the game world',
  icon: Icons.map,
  accentColor: Colors.deepOrangeAccent,
  lessonCount: 2,
  firstLessonTitle: 'Loading the Map',
  diagramAsset: 'assets/images/module_diagrams/module_3_map.svg',
);

Future<void> _pump(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MaterialApp(home: Scaffold(body: _page)));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the module header, diagram and lesson count', (
    tester,
  ) async {
    await _pump(tester, const Size(1280, 900));

    expect(find.text('MODULE 3 • OVERVIEW'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(
      find.text(
        '2 lessons in this module. Press Next to start with Loading the Map.',
      ),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel(RegExp('Map module diagram')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

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
