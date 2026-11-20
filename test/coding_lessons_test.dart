import 'package:bonfire_crash_course/presentation/pages/3_map/_map.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_3_apply_collision_to_player.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_4_move_and_jump.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_5_map_boundaries_for_player.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_6_player_attack_system.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_player.dart';
import 'package:bonfire_crash_course/presentation/pages/6_npc/_npc.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/code_snippet_card.dart';
import 'package:bonfire_crash_course/presentation/widgets/lesson/lesson.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every page built on [CodingScaffold].
const lessons = <String, Widget>{
  'Loading the Map': LoadingTheMap(),
  'Create Parallax Background': CreateParallaxBackground(),
  'Create Player Component': CreatePlayerComponentPage(),
  'Apply Gravity to Player': ApplyGravityToPlayerPage(),
  'Apply Collision to Player': ApplyCollisionToPlayerPage(),
  'Move and Jump': MoveAndJumpPage(),
  'Map Boundaries for Player': MapBoundariesForPlayerPage(),
  'Player Attack System': PlayerAttackSystemPage(),
  'Create Companion Component': CreateCompanionComponentPage(),
  'Companion Sprite Animations': CompanionSpriteAnimationsPage(),
  'Apply Gravity and Collision to Companion':
      ApplyGravityAndCollisionToCompanionPage(),
  'Companion Dialogue': CompanionDialoguePage(),
  'Companion Wave and Follow': CompanionWaveAndFollowPage(),
  'Companion Cutscene': CompanionCutscenePage(),
};

void main() {
  Future<void> pumpPage(WidgetTester tester, Widget page) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(body: page),
      ),
    );
    await tester.pumpAndSettle();
  }

  int words(String text) =>
      text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

  for (final MapEntry(key: name, value: page) in lessons.entries) {
    testWidgets('$name: short concepts that point at real code', (
      tester,
    ) async {
      await pumpPage(tester, page);
      final lesson = tester.widget<CodingScaffold>(find.byType(CodingScaffold));
      final code = lesson.codeSteps.map((s) => s.codeSnippet).join('\n');

      expect(words(lesson.outcome), lessThanOrEqualTo(14), reason: name);
      expect(lesson.concepts, isNotEmpty);
      for (final concept in lesson.concepts) {
        expect(
          words(concept.short),
          lessThanOrEqualTo(10),
          reason: concept.title,
        );
        final match = concept.codeMatch;
        if (match != null) {
          expect(code, contains(match), reason: '${concept.title}: $match');
        }
      }

      // One chip per concept, the first one explained, and the old reading
      // gone from the page.
      expect(find.byType(ConceptChip), findsNWidgets(lesson.concepts.length));
      expect(find.text(lesson.concepts.first.short), findsOneWidget);
      expect(find.text('Key Concepts'), findsNothing);
      expect(find.text('Lesson Objective'), findsNothing);
      expect(find.text("What You're About to Type"), findsNothing);
      expect(find.text('Watch the walkthrough'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Loading the Map: chips light up their code, full text on '
      'demand', (tester) async {
    await pumpPage(tester, const LoadingTheMap());
    final lesson = tester.widget<CodingScaffold>(find.byType(CodingScaffold));
    final camera = lesson.concepts.last;

    // BonfireWidget is picked first, and its lines are lit up.
    expect(find.byKey(const ValueKey('code-line-lit')), findsWidgets);
    expect(
      find.text(lesson.concepts.first.subtitle, findRichText: true),
      findsNothing,
    );

    await tester.tap(find.widgetWithText(ConceptChip, camera.title));
    await tester.pumpAndSettle();
    expect(find.text(camera.short), findsOneWidget);
    expect(find.text(lesson.concepts.first.short), findsNothing);
    // Only the CameraConfig( line is lit, in step 2.
    final snippets = tester
        .widgetList<CodeSnippetCard>(find.byType(CodeSnippetCard))
        .toList();
    expect(snippets.every((s) => s.highlightMatch == 'CameraConfig('), isTrue);
    expect(
      find.byKey(const ValueKey('code-line-lit')),
      findsNWidgets(
        lesson.codeSteps
            .expand((s) => s.codeSnippet.trim().split('\n'))
            .where((l) => l.contains('CameraConfig('))
            .length,
      ),
    );

    // Learn more shows the full explanation; nothing is lost.
    await tester.tap(find.text('Learn more').first);
    await tester.pumpAndSettle();
    expect(find.text(camera.subtitle), findsOneWidget);

    // Tapping the picked chip again clears the highlight.
    await tester.tap(find.widgetWithText(ConceptChip, camera.title));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('code-line-lit')), findsNothing);
    expect(find.text(camera.short), findsNothing);
  });

  testWidgets('the outcome hides the objective and code summary until asked', (
    tester,
  ) async {
    await pumpPage(tester, const LoadingTheMap());
    final lesson = tester.widget<CodingScaffold>(find.byType(CodingScaffold));
    final outcomeCard = find.byType(LessonOutcomeCard);

    expect(find.text(lesson.outcome), findsOneWidget);
    expect(find.text(lesson.objective), findsNothing);
    expect(find.text(lesson.proTip!), findsOneWidget);

    await tester.tap(
      find.descendant(of: outcomeCard, matching: find.text('Learn more')),
    );
    await tester.pumpAndSettle();
    expect(find.text(lesson.objective), findsOneWidget);
    expect(find.text(lesson.timeToCodeStatement), findsOneWidget);
  });

  testWidgets('Copy still copies the whole step', (tester) async {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await pumpPage(tester, const LoadingTheMap());
    final lesson = tester.widget<CodingScaffold>(find.byType(CodingScaffold));

    await tester.tap(find.text('Copy').first);
    await tester.pump();
    expect(copied, [lesson.codeSteps.first.codeSnippet.trim()]);
    expect(find.text('Copied'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Copied'), findsNothing);
  });
}
