import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/lotties/_lotties.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/_cards.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// A visually rewarding completion screen displayed when a user finishes a curriculum module.
///
/// Features animated celebration lotties, dynamic milestone badges, unlocked skill cards,
/// module metrics, and a "Next Up" guidance banner.
class ModuleCompletionPage extends StatelessWidget {
  final Module module;

  const ModuleCompletionPage({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Celebration Glow + StarBadgeLottie
              Stack(
                alignment: Alignment.center,
                children: [
                  // Ambient radial glow
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          module.accentColor.withValues(alpha: 0.28),
                          module.accentColor.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 180,
                    width: 180,
                    child: StarBadgeLottie(),
                  ),
                ],
              ),
              GapSizes.xsGap,

              // 2. Unit Complete Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: module.accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: module.accentColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(module.badgeIcon, color: module.accentColor, size: 15),
                    const Gap(8),
                    Text(
                      module.badgeText,
                      style: textTheme.labelMedium?.copyWith(
                        color: module.accentColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              GapSizes.smallGap,

              // 3. Headline & Description
              Text(
                module.completionHeadline,
                textAlign: TextAlign.center,
                style: textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const Gap(10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Text(
                  module.completionSubtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ),
              GapSizes.mediumGap,

              // 4. Milestone Metrics Summary Cards
              const Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      icon: Icons.check_circle_rounded,
                      color: Colors.greenAccent,
                      title: '100% Complete',
                      subtitle: 'All checkpoints passed',
                    ),
                  ),
                  Gap(14),
                  Expanded(
                    child: MetricCard(
                      icon: Icons.workspace_premium_rounded,
                      color: Colors.yellowAccent,
                      title: 'Milestone Achieved',
                      subtitle: 'Skill badge earned',
                    ),
                  ),
                  Gap(14),
                  Expanded(
                    child: MetricCard(
                      icon: Icons.sports_esports_rounded,
                      color: Colors.cyanAccent,
                      title: 'Live in Game',
                      subtitle: 'Code verified in engine',
                    ),
                  ),
                ],
              ),
              GapSizes.mediumGap,

              // 6. Up Next Guidance Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1E1E2C),
                      Colors.blueAccent.withValues(alpha: 0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.blueAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded,
                        color: Colors.blueAccent,
                        size: 24,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'UP NEXT',
                                style: textTheme.labelSmall?.copyWith(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const Gap(8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.blueAccent,
                                size: 14,
                              ),
                              const Gap(6),
                              Text(
                                module.nextModuleTitle,
                                style: textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Gap(4),
                          Text(
                            module.nextModuleDescription,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                    module.nextLottie,
                  ],
                ),
              ),
              GapSizes.largeGap,
            ],
          ),
        ),
      ),
    );
  }
}
