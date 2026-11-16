part of 'code_snippet_card.dart';

/// One line of code, lit up when the picked concept is on it.
class _CodeLine extends StatelessWidget {
  final List<TextSpan> spans;
  final TextStyle style;
  final bool lit;

  const _CodeLine({
    required this.spans,
    required this.style,
    required this.lit,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: lit ? CodeSnippetCard.highlightColor : Colors.transparent,
        border: Border(
          left: BorderSide(
            width: 3,
            color: lit ? CodeSnippetCard.highlightBarColor : Colors.transparent,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Text.rich(
        TextSpan(children: spans.isEmpty ? null : spans),
        key: lit ? const ValueKey('code-line-lit') : null,
        style: style,
        softWrap: true,
      ),
    );
  }
}
