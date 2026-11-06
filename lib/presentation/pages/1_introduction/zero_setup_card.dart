part of 'what_you_will_need.dart';

/// "Zero setup": a Rive animation and a few checkmarks for what the cloud
/// workspace already has ready.
class ZeroSetupCard extends StatelessWidget {
  /// At most three short lines.
  final List<String> checks;

  const ZeroSetupCard({super.key, required this.checks});

  /// The animation's height; the artboard is 16:9.
  static const animationHeight = 160.0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: onboardingCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.cloud_queue_rounded,
                color: Colors.cyanAccent,
                size: 24,
              ),
              GapSizes.smallGap,
              Text(
                'Zero setup',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          GapSizes.mediumGap,
          const Center(
            child: SizedBox(
              height: animationHeight,
              width: animationHeight * 16 / 9,
              child: GettingStartedRive(scene: GettingStartedScene.zeroSetup),
            ),
          ),
          GapSizes.mediumGap,
          for (final check in checks)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_rounded,
                    color: Colors.greenAccent,
                    size: 20,
                  ),
                  GapSizes.smallGap,
                  Expanded(
                    child: Text(
                      check,
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
