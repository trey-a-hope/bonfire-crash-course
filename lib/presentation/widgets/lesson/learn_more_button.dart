part of 'lesson.dart';

/// A small "Learn more" / "Show less" text button.
class LearnMoreButton extends StatelessWidget {
  /// Whether the extra text is showing.
  final bool expanded;

  /// Called when the button is pressed.
  final VoidCallback onPressed;

  const LearnMoreButton({
    super.key,
    required this.expanded,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.lightBlueAccent,
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 32),
        textStyle: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      child: Text(
        expanded ? 'Show less' : 'Learn more',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Colors.lightBlueAccent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
