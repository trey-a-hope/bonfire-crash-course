import 'package:bonfire_crash_course/presentation/pages/unit_completion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('UnitCompletionPage renders Map unit completion details',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: UnitCompletionPage(unitName: 'Map'),
        ),
      ),
    );

    expect(find.text('Map & World Complete!'), findsOneWidget);
    expect(find.text('MAP ARCHITECT'), findsOneWidget);
    expect(find.text('Tilemap Integration'), findsOneWidget);
    expect(find.text('Parallax Scenery'), findsOneWidget);
    expect(find.text('Camera Boundaries'), findsOneWidget);
    expect(find.text('World Physics'), findsOneWidget);
    expect(find.text('UP NEXT'), findsOneWidget);
  });

  testWidgets('UnitCompletionPage renders Player unit completion details',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: UnitCompletionPage(unitName: 'Player'),
        ),
      ),
    );

    expect(find.text('Player Character Ready!'), findsOneWidget);
    expect(find.text('HERO CONTROLLER'), findsOneWidget);
    expect(find.text('Sprite Animations'), findsOneWidget);
    expect(find.text('Fluid Controls'), findsOneWidget);
    expect(find.text('UP NEXT'), findsOneWidget);
  });

  testWidgets('UnitCompletionPage renders Bonfire Crash Course completion details',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: UnitCompletionPage(unitName: 'Bonfire Crash Course'),
        ),
      ),
    );

    expect(find.text('Crash Course Completed!'), findsOneWidget);
    expect(find.text('BONFIRE CHAMPION'), findsOneWidget);
    expect(find.text('Bonfire Engine Master'), findsOneWidget);
    expect(find.text('Ready for Indie Publishing'), findsOneWidget);
  });
}
