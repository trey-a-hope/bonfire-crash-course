part of 'lesson.dart';

/// One concept name above a lesson's code. Picked, it turns yellow, the same
/// colour as the code lines it lights up.
class ConceptChip extends StatelessWidget {
  /// The concept's name.
  final String label;

  /// Whether this concept is the one being explained.
  final bool selected;

  /// Called when the chip is tapped.
  final VoidCallback onTap;

  const ConceptChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected
            ? lessonHighlight.withValues(alpha: 0.15)
            : Colors.transparent,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected
                ? lessonHighlight.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
