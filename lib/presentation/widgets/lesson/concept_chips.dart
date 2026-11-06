part of 'lesson.dart';

/// The lesson's concepts as a row of chips, with the picked one explained
/// underneath in a single line.
class ConceptChips extends StatelessWidget {
  /// The lesson's concepts, in order.
  final List<Concept> concepts;

  /// Index of the picked concept, or null when none is picked.
  final int? selected;

  /// Called with the tapped concept's index, or null when the picked chip is
  /// tapped again.
  final ValueChanged<int?> onSelected;

  const ConceptChips({
    super.key,
    required this.concepts,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final picked = selected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tap a word to see what it does and where it goes',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        GapSizes.smallGap,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < concepts.length; i++)
              ConceptChip(
                label: concepts[i].title,
                selected: i == picked,
                onTap: () => onSelected(i == picked ? null : i),
              ),
          ],
        ),
        if (picked != null) ...[
          GapSizes.smallGap,
          ConceptExplainer(key: ValueKey(picked), concept: concepts[picked]),
        ],
      ],
    );
  }
}
