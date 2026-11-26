import 'package:bonfire_crash_course/presentation/widgets/cards/code_snippet_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// A snippet like the Create Enemy "Remove the player-only controls" step:
/// comments and a blank line unmarked, every code line removed.
const _removedSnippet = '''
// The joystick handler.
- @override
- void onJoystickAction(JoystickActionEvent event) {
-   ...
- }

// The projectile attack.
- void _rangeAttack() {}
''';

/// A snippet with one added line between unmarked context lines.
const _addedSnippet = '''
return BonfireWidget(
  map: WorldMapBySpritefusion(...),
+   components: [ MinorEnemy(Vector2(1000, 100)) ],
);
''';

/// Shows [code] in a [CodeSnippetCard] the way a lesson page does.
Future<void> _pumpCard(WidgetTester tester, String code) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: CodeSnippetCard(code: code, fileName: 'game_screen.dart'),
        ),
      ),
    ),
  );
}

/// The background color of the code line whose text contains [text].
Color? _lineBackground(WidgetTester tester, String text) {
  final container = tester.widget<AnimatedContainer>(
    find
        .ancestor(
          of: find.textContaining(text, findRichText: true),
          matching: find.byType(AnimatedContainer),
        )
        .first,
  );
  return (container.decoration! as BoxDecoration).color;
}

/// The left bar color of the code line whose text contains [text].
Color _lineBar(WidgetTester tester, String text) {
  final container = tester.widget<AnimatedContainer>(
    find
        .ancestor(
          of: find.textContaining(text, findRichText: true),
          matching: find.byType(AnimatedContainer),
        )
        .first,
  );
  final border = (container.decoration! as BoxDecoration).border! as Border;
  return border.left.color;
}

void main() {
  // The pure marker parser: which lines count as added or removed, and the
  // code the highlighter sees.
  group('parseCodeSnippet', () {
    test('reads "+ " and "- " at column 0 and strips the marker', () {
      final parsed = parseCodeSnippet('+ final a = 1;\n- final b = 2;\nc();');
      expect(parsed.code, 'final a = 1;\nfinal b = 2;\nc();');
      expect(parsed.kinds, [
        CodeLineKind.added,
        CodeLineKind.removed,
        CodeLineKind.unchanged,
      ]);
    });

    test('a bare "+" or "-" is a marked blank line', () {
      final parsed = parseCodeSnippet('a();\n+\n-\nb();');
      expect(parsed.code, 'a();\n\n\nb();');
      expect(parsed.kinds, [
        CodeLineKind.unchanged,
        CodeLineKind.added,
        CodeLineKind.removed,
        CodeLineKind.unchanged,
      ]);
    });

    test('keeps the indentation after the marker', () {
      final parsed = parseCodeSnippet('a(\n+   b: 1,\n);');
      expect(parsed.code, 'a(\n  b: 1,\n);');
    });

    test('mid-line and indented signs are ordinary code', () {
      const code = 'a - b;\n  - c;\nx++;\n--x;\n-1;\n+1;\n-x;';
      final parsed = parseCodeSnippet(code);
      expect(parsed.code, code);
      expect(parsed.kinds, everyElement(CodeLineKind.unchanged));
    });

    test('finds markers after the leading newline of a triple-quoted '
        'string', () {
      final parsed = parseCodeSnippet(_addedSnippet);
      expect(parsed.kinds, [
        CodeLineKind.unchanged,
        CodeLineKind.unchanged,
        CodeLineKind.added,
        CodeLineKind.unchanged,
      ]);
      expect(
        parsed.code.split('\n')[2],
        '  components: [ MinorEnemy('
        'Vector2(1000, 100)) ],',
      );
    });

    test('a snippet with no markers is trimmed exactly as before', () {
      const code = '\n\n   void main() {\n  run();\n}  \n\n';
      final parsed = parseCodeSnippet(code);
      expect(parsed.code, code.trim());
      expect(parsed.kinds, everyElement(CodeLineKind.unchanged));
    });

    test('never trims away a marked line at either end', () {
      final parsed = parseCodeSnippet('\n+\na();\n-\n');
      expect(parsed.kinds, [
        CodeLineKind.added,
        CodeLineKind.unchanged,
        CodeLineKind.removed,
      ]);
    });
  });

  // What the Copy button puts on the clipboard.
  group('copyableCodeSnippet', () {
    test('copies only the added lines, without markers', () {
      expect(
        copyableCodeSnippet(_addedSnippet),
        'components: [ MinorEnemy(Vector2(1000, 100)) ],',
      );
      expect(copyableCodeSnippet('keep();\n- gone();\n+ added();'), 'added();');
    });

    test('copies the Loading the Map step as the green lines', () {
      expect(
        copyableCodeSnippet('''
@override
Widget build(BuildContext context) {
-    return Placeholder(color: Colors.green);
+    return BonfireWidget(
+        map: WorldMapBySpritefusion(
+            WorldMapReader.fromAsset(MAP_ONE),
+        ),
    );
}
'''),
        'return BonfireWidget(\n'
        '    map: WorldMapBySpritefusion(\n'
        '        WorldMapReader.fromAsset(MAP_ONE),\n'
        '    ),',
      );
    });

    test('drops removed lines when nothing is added', () {
      expect(copyableCodeSnippet('keep();\n- gone();'), 'keep();');
    });

    test('still strips comments, so an all-removed snippet copies '
        'nothing', () {
      expect(copyableCodeSnippet(_removedSnippet), '');
    });

    test('still dedents unmarked snippets', () {
      expect(
        copyableCodeSnippet('''
    void main() {
      // Start the app.
      run();
    }
'''),
        'void main() {\n  run();\n}',
      );
    });

    test('a mid-line minus is copied unchanged', () {
      expect(copyableCodeSnippet('final c = a - b;'), 'final c = a - b;');
    });
  });

  // How the card renders marked and unmarked snippets.
  group('CodeSnippetCard', () {
    testWidgets('an unmarked snippet has no gutter signs', (tester) async {
      await _pumpCard(tester, 'void main() {\n  run();\n}');
      expect(find.text('+'), findsNothing);
      expect(find.text('−'), findsNothing);
      expect(find.byType(Row), findsNWidgets(3)); // header rows only
      expect(_lineBackground(tester, 'run'), Colors.transparent);
    });

    testWidgets('an added line is green with a "+" sign and no marker', (
      tester,
    ) async {
      await _pumpCard(tester, _addedSnippet);

      expect(find.text('+'), findsOneWidget);
      expect(find.textContaining('+ ', findRichText: true), findsNothing);
      expect(_lineBackground(tester, 'components'), CodeSnippetCard.addedColor);
      expect(_lineBar(tester, 'components'), CodeSnippetCard.addedBarColor);
      expect(_lineBackground(tester, 'map:'), Colors.transparent);

      final sign = tester.widget<Text>(find.text('+'));
      expect(sign.style?.color, CodeSnippetCard.addedBarColor);
      expect(sign.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('a removed line is red with a "−" sign', (tester) async {
      await _pumpCard(tester, _removedSnippet);

      expect(find.text('−'), findsNWidgets(5));
      expect(
        _lineBackground(tester, 'onJoystickAction'),
        CodeSnippetCard.removedColor,
      );
      expect(
        _lineBar(tester, 'onJoystickAction'),
        CodeSnippetCard.removedBarColor,
      );
      // Comments stay unmarked.
      expect(_lineBackground(tester, 'joystick handler'), Colors.transparent);
    });

    testWidgets('keeps syntax highlighting on a marked line', (tester) async {
      await _pumpCard(tester, '- void _rangeAttack() {}');
      final rich = tester.widget<RichText>(
        find.textContaining('_rangeAttack', findRichText: true).first,
      );
      final runs = <TextSpan>[];
      rich.text.visitChildren((span) {
        if (span is TextSpan && span.text != null) runs.add(span);
        return true;
      });
      // "void" is a keyword, so the highlighter gave it its own style.
      expect(
        runs.any((r) => r.text == 'void' && r.style?.color != null),
        isTrue,
      );
    });

    testWidgets('signs are labelled for screen readers', (tester) async {
      final handle = tester.ensureSemantics();
      await _pumpCard(tester, 'a();\n+ b();\n- c();');
      expect(find.bySemanticsLabel('Added'), findsOneWidget);
      expect(find.bySemanticsLabel('Removed'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('Copy puts only the added lines on the '
        'clipboard', (tester) async {
      // Records what Copy writes to the platform clipboard.
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String?;
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

      await _pumpCard(tester, 'keep();\n- gone();\n+ added();');
      await tester.tap(find.text('Copy'));
      await tester.pump();
      expect(copied, 'added();');
      // Let the 2-second "Copied" timer finish.
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('hides Copy when every line is removed', (tester) async {
      await _pumpCard(tester, _removedSnippet);
      expect(find.text('Copy'), findsNothing);
    });

    testWidgets('shows Copy when something is left to paste', (tester) async {
      await _pumpCard(tester, _addedSnippet);
      expect(find.text('Copy'), findsOneWidget);
    });
  });
}
