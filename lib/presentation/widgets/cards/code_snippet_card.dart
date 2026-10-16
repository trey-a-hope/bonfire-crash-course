import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:highlight/highlight.dart' show highlight, Node;

/// A card widget that displays syntax-highlighted Dart code with a header bar
/// showing the [fileName] and a button to copy [code] to the clipboard.
class CodeSnippetCard extends StatefulWidget {
  /// The source code snippet to display and copy.
  final String code;

  /// The name of the file or label displayed in the header bar.
  final String fileName;

  const CodeSnippetCard({
    super.key,
    required this.code,
    required this.fileName,
  });

  @override
  State<CodeSnippetCard> createState() => _CodeSnippetCardState();
}

class _CodeSnippetCardState extends State<CodeSnippetCard> {
  /// Tracks whether the code snippet was recently copied for visual feedback.
  bool _copied = false;

  /// Copies the code snippet to the system clipboard and temporarily shows
  /// confirmation feedback for 2 seconds.
  void _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.code.trim()));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  TextSpan _convertNode(Node node) {
    final style = atomOneDarkTheme[node.className];
    if (node.value != null) {
      return TextSpan(text: node.value, style: style);
    }
    if (node.children != null) {
      return TextSpan(
        style: style,
        children: node.children!.map((n) => _convertNode(n)).toList(),
      );
    }
    return const TextSpan();
  }

  Widget _buildHighlightView() {
    final code = widget.code.trim();
    final result = highlight.parse(code, language: 'dart');

    final rootStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 13,
      height: 1.5,
      color: atomOneDarkTheme['root']?.color ?? const Color(0xffabb2bf),
    );

    final spans = <TextSpan>[];
    if (result.nodes != null) {
      for (final node in result.nodes!) {
        spans.add(_convertNode(node));
      }
    }

    return Container(
      color:
          atomOneDarkTheme['root']?.backgroundColor ?? const Color(0xff282c34),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: SelectableText.rich(
        TextSpan(
          style: rootStyle,
          children: spans,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  Row(
                    children: [
                      const Icon(
                        Icons.code_rounded,
                        size: 16,
                        color: Colors.blueAccent,
                      ),
                      GapSizes.smallGap,
                      Text(
                        widget.fileName,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
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
                            _copied ? Icons.check_rounded : Icons.copy_rounded,
                            size: 14,
                            color: _copied
                                ? Colors.greenAccent
                                : Colors.white60,
                          ),
                          GapSizes.xsGap,
                          Text(
                            _copied ? 'Copied' : 'Copy',
                            style: TextStyle(
                              color: _copied
                                  ? Colors.greenAccent
                                  : Colors.white60,
                              fontSize: 11,
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
