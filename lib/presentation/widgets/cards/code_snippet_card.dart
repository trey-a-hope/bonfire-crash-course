import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:highlight/highlight.dart' show highlight, Node;
import 'package:signals/signals_flutter.dart';

part 'code_line.dart';
part 'code_line_kind.dart';
part 'code_line_sign.dart';

/// A snippet after its `+ ` / `- ` markers are read: [code] is the text with
/// the markers stripped, and [kinds] has one entry per line of [code].
typedef ParsedCodeSnippet = ({String code, List<CodeLineKind> kinds});

/// Reads the added and removed markers a lesson author put on [snippet].
///
/// A line that starts at column 0 with `+ `, or is exactly `+`, is added; `- `
/// or exactly `-` is removed. The sign and one space are stripped, so the
/// highlighter sees plain Dart. Anything else (an indented `-`, `a - b`,
/// `x++`, `--x`) is ordinary code.
///
/// The result is trimmed the way `String.trim` trims a snippet today (blank
/// lines at both ends, and the outer whitespace of the first and last line),
/// except that a marked line is never dropped. Markers are found before the
/// trim, so the leading newline of a `'''` string doesn't hide one.
@visibleForTesting
ParsedCodeSnippet parseCodeSnippet(String snippet) {
  final (:lines, :kinds) = _readMarkers(snippet);
  bool blank(int i) =>
      kinds[i] == CodeLineKind.unchanged && lines[i].trim().isEmpty;

  var start = 0;
  while (start < lines.length && blank(start)) {
    start++;
  }
  var end = lines.length;
  while (end > start && blank(end - 1)) {
    end--;
  }
  // An empty snippet still renders one empty line, as it did before markers.
  if (start == end) return (code: '', kinds: const [CodeLineKind.unchanged]);

  final kept = lines.sublist(start, end);
  final keptKinds = kinds.sublist(start, end);
  // Same as trim(): only unmarked end lines lose their outer whitespace, so a
  // marked line keeps the indentation its author gave it.
  if (keptKinds.first == CodeLineKind.unchanged) {
    kept[0] = kept[0].trimLeft();
  }
  if (keptKinds.last == CodeLineKind.unchanged) {
    kept[kept.length - 1] = kept.last.trimRight();
  }
  return (code: kept.join('\n'), kinds: keptKinds);
}

/// The text the Copy button puts on the clipboard for [snippet].
///
/// Removed lines are dropped and added lines keep their code without the
/// marker. Then every comment is removed and the shared indentation is cut,
/// as before markers existed.
@visibleForTesting
String copyableCodeSnippet(String snippet) {
  // Untrimmed on purpose: trimming would strip the first line's indentation
  // and change how much the dedent cuts.
  final (:lines, :kinds) = _readMarkers(snippet);
  return _withoutComments(
    [
      for (var i = 0; i < lines.length; i++)
        if (kinds[i] != CodeLineKind.removed) lines[i],
    ].join('\n'),
  );
}

/// Splits [snippet] into lines and reads each line's marker, stripping it.
({List<String> lines, List<CodeLineKind> kinds}) _readMarkers(String snippet) {
  final lines = <String>[];
  final kinds = <CodeLineKind>[];
  for (final line in snippet.split('\n')) {
    final kind = switch (line) {
      '+' => CodeLineKind.added,
      '-' => CodeLineKind.removed,
      _ when line.startsWith('+ ') => CodeLineKind.added,
      _ when line.startsWith('- ') => CodeLineKind.removed,
      _ => CodeLineKind.unchanged,
    };
    kinds.add(kind);
    // The marker is the sign plus one space; a bare sign leaves a blank line.
    lines.add(switch (kind) {
      CodeLineKind.unchanged => line,
      _ => line.length > 1 ? line.substring(2) : '',
    });
  }
  return (lines: lines, kinds: kinds);
}

/// [code] with every comment removed, ready to paste into a file.
///
/// Uses the highlighter's parse tree, so `//` inside a string is safe.
/// Lines that held only a comment are dropped entirely, so no stray blank
/// lines are left behind.
String _withoutComments(String code) {
  final lines = <StringBuffer>[StringBuffer()];
  final hadComment = <bool>[false];

  void newLine() {
    lines.add(StringBuffer());
    hadComment.add(false);
  }

  String textOf(Node n) =>
      (n.value ?? '') + (n.children ?? const <Node>[]).map(textOf).join();

  void visit(Node node) {
    if (node.className == 'comment') {
      // Skip the text, but remember which lines it touched.
      hadComment[hadComment.length - 1] = true;
      for (final _ in '\n'.allMatches(textOf(node))) {
        newLine();
        hadComment[hadComment.length - 1] = true;
      }
      return;
    }
    if (node.value != null) {
      final parts = node.value!.split('\n');
      for (var i = 0; i < parts.length; i++) {
        if (i > 0) newLine();
        lines.last.write(parts[i]);
      }
    }
    for (final child in node.children ?? const <Node>[]) {
      visit(child);
    }
  }

  for (final node in highlight.parse(code, language: 'dart').nodes ?? []) {
    visit(node);
  }

  final kept = <String>[];
  for (var i = 0; i < lines.length; i++) {
    final text = lines[i].toString().trimRight(); // no trailing whitespace
    if (hadComment[i] && text.isEmpty) continue; // comment-only line
    kept.add(text);
  }
  return _dedent(kept).join('\n').trim();
}

/// Removes the indentation shared by every non-empty line.
List<String> _dedent(List<String> lines) {
  final indents = lines
      .where((l) => l.trim().isNotEmpty)
      .map((l) => l.length - l.trimLeft().length);
  if (indents.isEmpty) return lines;
  final cut = indents.reduce((a, b) => a < b ? a : b);
  return [for (final l in lines) l.length >= cut ? l.substring(cut) : l];
}

/// A card widget that displays syntax-highlighted Dart code with a header bar
/// showing the [fileName] and a button to copy [code] to the clipboard.
///
/// Lines the author marks with `+ ` or `- ` at column 0 show as added (green)
/// or removed (red), with a sign in a gutter; see [parseCodeSnippet].
class CodeSnippetCard extends SignalStatefulWidget {
  /// The source code snippet to display and copy, optionally with `+ ` and
  /// `- ` markers at column 0 for added and removed lines.
  final String code;

  /// The name of the file or label displayed in the header bar.
  final String fileName;

  const CodeSnippetCard({
    super.key,
    required this.code,
    required this.fileName,
  });

  /// Background of an added (`+ `) line.
  static const addedColor = Color(0x333FB950);

  /// Bar and "+" sign of an added line.
  static const addedBarColor = Color(0xFF56D364);

  /// Background of a removed (`- `) line.
  static const removedColor = Color(0x33F85149);

  /// Bar and "−" sign of a removed line.
  static const removedBarColor = Color(0xFFFF8A80);

  @override
  State<CodeSnippetCard> createState() => _CodeSnippetCardState();
}

/// Holds the "Copied" feedback for [CodeSnippetCard] and builds its header
/// and highlighted code.
class _CodeSnippetCardState extends State<CodeSnippetCard> {
  /// Whether the code snippet was recently copied, for visual feedback.
  final _copied = Signal<bool>(false);

  @override
  void dispose() {
    _copied.dispose();
    super.dispose();
  }

  /// Copies the code snippet to the system clipboard and temporarily shows
  /// confirmation feedback for 2 seconds.
  Future<void> _copyCode() async {
    try {
      await Clipboard.setData(
        ClipboardData(text: copyableCodeSnippet(widget.code)),
      );
    } catch (error) {
      debugPrint('Copy failed: $error');
      return;
    }
    if (!mounted) return;
    _copied.value = true;
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) _copied.value = false;
  }

  /// Flattens the highlighted tree into styled runs, split into lines.
  List<List<TextSpan>> _lines(String code) {
    final lines = <List<TextSpan>>[[]];
    void visit(Node node, TextStyle? inherited) {
      final own = atomOneDarkTheme[node.className];
      final style = inherited?.merge(own) ?? own;
      if (node.value != null) {
        final parts = node.value!.split('\n');
        for (var i = 0; i < parts.length; i++) {
          if (i > 0) lines.add([]);
          if (parts[i].isNotEmpty) {
            lines.last.add(TextSpan(text: parts[i], style: style));
          }
        }
      }
      for (final child in node.children ?? const <Node>[]) {
        visit(child, style);
      }
    }

    for (final node in highlight.parse(code, language: 'dart').nodes ?? []) {
      visit(node, null);
    }
    return lines;
  }

  /// The dark code area: one [_CodeLine] per line of the snippet.
  Widget _buildHighlightView() {
    final (:code, :kinds) = parseCodeSnippet(widget.code);
    // The gutter only appears when something is marked, so unmarked
    // snippets keep today's spacing.
    final showGutter = kinds.any((k) => k != CodeLineKind.unchanged);

    final rootStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontFamily: 'monospace',
      height: 1.5,
      color: atomOneDarkTheme['root']?.color ?? const Color(0xffabb2bf),
    );

    final lines = _lines(code);
    return Container(
      color:
          atomOneDarkTheme['root']?.backgroundColor ?? const Color(0xff282c34),
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < lines.length; i++)
              _CodeLine(
                spans: lines[i],
                style: rootStyle,
                kind: i < kinds.length ? kinds[i] : CodeLineKind.unchanged,
                showGutter: showGutter,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final copied = _copied.value;
    // A step that only removes code leaves nothing to paste, so hide Copy.
    final canCopy = copyableCodeSnippet(widget.code).isNotEmpty;
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Bar: Displays the file name and the copy button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: const Color(0xFF181825),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // File icon and file name
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.code_rounded,
                          size: 16,
                          color: Colors.blueAccent,
                        ),
                        GapSizes.smallGap,
                        Flexible(
                          child: Text(
                            widget.fileName,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Copy to clipboard button with animated state feedback
                  if (canCopy)
                    InkWell(
                      onTap: _copyCode,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              copied ? Icons.check_rounded : Icons.copy_rounded,
                              size: 14,
                              color: copied
                                  ? Colors.greenAccent
                                  : Colors.white60,
                            ),
                            GapSizes.xsGap,
                            Text(
                              copied ? 'Copied' : 'Copy',
                              style: textTheme.bodyMedium?.copyWith(
                                color: copied
                                    ? Colors.greenAccent
                                    : Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Code Area: Syntax-highlighted Dart source code
            _buildHighlightView(),
          ],
        ),
      ),
    );
  }
}
