import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:highlight/highlight.dart' show highlight, Node;
import 'package:signals/signals_flutter.dart';

part 'code_line.dart';

/// A card widget that displays syntax-highlighted Dart code with a header bar
/// showing the [fileName] and a button to copy [code] to the clipboard.
class CodeSnippetCard extends SignalStatefulWidget {
  /// The source code snippet to display and copy.
  final String code;

  /// The name of the file or label displayed in the header bar.
  final String fileName;

  /// When set, every line containing this text is lit up, so a lesson can
  /// point at the code a concept is about.
  final String? highlightMatch;

  const CodeSnippetCard({
    super.key,
    required this.code,
    required this.fileName,
    this.highlightMatch,
  });

  /// Background of a lit-up line.
  static const highlightColor = Color(0x24FFD740);

  /// Bar on the left of a lit-up line.
  static const highlightBarColor = Color(0xFFFFD740);

  @override
  State<CodeSnippetCard> createState() => _CodeSnippetCardState();
}

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
      await Clipboard.setData(ClipboardData(text: widget.code.trim()));
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

  Widget _buildHighlightView() {
    final code = widget.code.trim();
    final match = widget.highlightMatch;
    final sourceLines = code.split('\n');

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
                lit:
                    match != null &&
                    i < sourceLines.length &&
                    sourceLines[i].contains(match),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final copied = _copied.value;
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
                            color: copied ? Colors.greenAccent : Colors.white60,
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
