part of 'what_you_will_need.dart';

/// One must-have: a big icon, a short title and one short line. It fades and
/// slides in after [delay], or appears at once when reduced motion is on.
class NeedTile extends StatelessWidget {
  final IconData icon;
  final Color color;

  /// A few words.
  final String title;

  /// One short line, about six words.
  final String line;

  /// How long to wait before sliding in.
  final Duration delay;

  const NeedTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.line,
    this.delay = Duration.zero,
  });

  /// How long the slide-in takes once it starts.
  static const slideDuration = Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final total = delay + slideDuration;
    final start = delay.inMicroseconds / total.inMicroseconds;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
      duration: reduceMotion ? Duration.zero : total,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 16),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: onboardingCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            GapSizes.mediumGap,
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            GapSizes.xsGap,
            Text(
              line,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
