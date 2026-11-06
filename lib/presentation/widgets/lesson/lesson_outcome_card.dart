part of 'lesson.dart';

/// What the student will have when the lesson is done, in one line. The full
/// objective and a summary of what they're about to type sit behind
/// "Learn more".
class LessonOutcomeCard extends SignalStatefulWidget {
  /// The result of the lesson, in one line.
  final String outcome;

  /// The full lesson objective.
  final String objective;

  /// A summary of the code the student is about to type.
  final String timeToCodeStatement;

  const LessonOutcomeCard({
    super.key,
    required this.outcome,
    required this.objective,
    required this.timeToCodeStatement,
  });

  @override
  State<LessonOutcomeCard> createState() => _LessonOutcomeCardState();
}

class _LessonOutcomeCardState extends State<LessonOutcomeCard> {
  /// Whether the objective and code summary are showing.
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
    final detailStyle = textTheme.bodyMedium?.copyWith(
      color: Colors.white.withValues(alpha: 0.8),
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: lessonCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WHEN YOU'RE DONE",
            style: textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          GapSizes.smallGap,
          Text(
            widget.outcome,
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (expanded) ...[
            GapSizes.smallGap,
            Text(widget.objective, style: detailStyle),
            GapSizes.smallGap,
            Text(widget.timeToCodeStatement, style: detailStyle),
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
