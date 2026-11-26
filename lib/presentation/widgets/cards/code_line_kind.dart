part of 'code_snippet_card.dart';

/// What a lesson author marked a snippet line as, read by
/// [parseCodeSnippet] from a `+ ` or `- ` marker at column 0.
///
/// [CodeSnippetCard] tints added and removed lines and draws their sign in
/// the gutter, and the Copy button drops removed lines.
enum CodeLineKind {
  /// Ordinary code with no marker. Shown and copied as written.
  unchanged,

  /// A line the learner adds (`+ ` marker). Green, with a "+" sign.
  added,

  /// A line the learner deletes (`- ` marker). Red, with a "−" sign, and
  /// left out of the copied code.
  removed,
}
