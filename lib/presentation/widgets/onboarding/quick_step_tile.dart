part of 'onboarding.dart';

/// One numbered step in [QuickSteps]. It fades and slides in after [delay],
/// or appears at once when the platform asks for reduced motion.
class QuickStepTile extends StatelessWidget {
  /// The step's number, starting at 1.
  final int number;

  /// The step, in a few words.
  final String text;

  /// How long to wait before sliding in.
  final Duration delay;

  const QuickStepTile({
    super.key,
    required this.number,
    required this.text,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final total = delay + QuickSteps.stepDuration;
    final start = total.inMicroseconds == 0
        ? 0.0
        : delay.inMicroseconds / total.inMicroseconds;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
      duration: reduceMotion ? Duration.zero : total,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 12),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: onboardingCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: onboardingAccent.withValues(alpha: 0.15),
                border: Border.all(
                  color: onboardingAccent.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                '$number',
                style: textTheme.labelLarge?.copyWith(
                  color: onboardingAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GapSizes.mediumGap,
            Expanded(
              child: Text(
                text,
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
