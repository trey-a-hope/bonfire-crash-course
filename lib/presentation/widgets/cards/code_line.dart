part of 'code_snippet_card.dart';

/// One line of code in [CodeSnippetCard]: lit up yellow when the picked
/// concept is on it, or tinted green or red when the author marked it as
/// added or removed.
class _CodeLine extends StatelessWidget {
  /// The syntax-highlighted runs of this line, marker already stripped.
  final List<TextSpan> spans;

  /// The monospace base style every run merges onto.
  final TextStyle style;

  /// Whether the concept the learner picked is on this line.
  final bool lit;

  /// Whether the author marked this line as added, removed, or neither.
  final CodeLineKind kind;

  /// Whether the snippet has any marked line. Then every line, marked or
  /// not, gets the sign gutter so the code stays aligned.
  final bool showGutter;

  const _CodeLine({
    required this.spans,
    required this.style,
    required this.lit,
    this.kind = CodeLineKind.unchanged,
    this.showGutter = false,
  });

  @override
  Widget build(BuildContext context) {
    // The concept highlight wins over added/removed for the background and
    // bar; the sign below keeps its own color so the meaning survives.
    final (background, bar) = lit
        ? (CodeSnippetCard.highlightColor, CodeSnippetCard.highlightBarColor)
        : switch (kind) {
            CodeLineKind.added => (
              CodeSnippetCard.addedColor,
              CodeSnippetCard.addedBarColor,
            ),
            CodeLineKind.removed => (
              CodeSnippetCard.removedColor,
              CodeSnippetCard.removedBarColor,
            ),
            CodeLineKind.unchanged => (Colors.transparent, Colors.transparent),
          };

    final text = Text.rich(
      TextSpan(children: spans.isEmpty ? null : spans),
      key: lit ? const ValueKey('code-line-lit') : null,
      style: style,
      softWrap: true,
    );

    return AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: background,
        border: Border(left: BorderSide(width: 3, color: bar)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      // Unmarked snippets keep the plain layout they always had.
      child: showGutter
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 12px sign cell (empty on unmarked lines), then an 8px gap.
                SizedBox(
                  width: 12,
                  child: kind == CodeLineKind.unchanged
                      ? null
                      : _CodeLineSign(kind: kind, style: style),
                ),
                const SizedBox(width: 8),
                Expanded(child: text),
              ],
            )
          : text,
    );
  }
}
