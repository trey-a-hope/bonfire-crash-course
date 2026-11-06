part of 'lesson.dart';

/// What the picked concept does in one line, with its full explanation
/// behind "Learn more".
class ConceptExplainer extends SignalStatefulWidget {
  /// The concept to explain.
  final Concept concept;

  const ConceptExplainer({super.key, required this.concept});

  @override
  State<ConceptExplainer> createState() => _ConceptExplainerState();
}

class _ConceptExplainerState extends State<ConceptExplainer> {
  /// Whether the full explanation is showing.
  final _expanded = Signal<bool>(false);

  @override
  void dispose() {
    _expanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final expanded = _expanded.value;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      decoration: BoxDecoration(
        color: lessonHighlight.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: lessonHighlight.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.concept.short,
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (expanded) ...[
            GapSizes.xsGap,
            Text(
              widget.concept.subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
          LearnMoreButton(
            expanded: expanded,
            onPressed: () => _expanded.value = !expanded,
          ),
        ],
      ),
    );
  }
}
