part of 'code_snippet_card.dart';

/// The "+" or "−" in a marked [_CodeLine]'s gutter.
///
/// It is left out of text selection, so selecting and copying code never
/// picks up the sign, and screen readers hear "Added" or "Removed" instead
/// of the symbol.
class _CodeLineSign extends StatelessWidget {
  /// Added or removed; never [CodeLineKind.unchanged].
  final CodeLineKind kind;

  /// The line's base style, so the sign sits on the same baseline and
  /// line height as the code next to it.
  final TextStyle style;

  const _CodeLineSign({required this.kind, required this.style});

  @override
  Widget build(BuildContext context) {
    final added = kind == CodeLineKind.added;
    return SelectionContainer.disabled(
      child: Semantics(
        label: added ? 'Added' : 'Removed',
        excludeSemantics: true,
        child: Text(
          // U+2212 minus sign, not a hyphen, so it matches the "+" width.
          added ? '+' : '−',
          textAlign: TextAlign.center,
          style: style.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: added
                ? CodeSnippetCard.addedBarColor
                : CodeSnippetCard.removedBarColor,
          ),
        ),
      ),
    );
  }
}
