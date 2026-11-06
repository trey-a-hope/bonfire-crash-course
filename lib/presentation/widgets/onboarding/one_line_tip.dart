part of 'onboarding.dart';

/// A single short tip under a page's steps.
class OneLineTip extends StatelessWidget {
  /// The tip, in one line.
  final String text;

  const OneLineTip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.lightbulb_outline_rounded,
          color: Colors.cyanAccent,
          size: 18,
        ),
        GapSizes.smallGap,
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ),
      ],
    );
  }
}
