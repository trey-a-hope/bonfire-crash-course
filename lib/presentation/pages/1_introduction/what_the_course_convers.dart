import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/lotties/bonfire_lottie.dart';
import 'package:flutter/material.dart';

class WhatTheCourseConvers extends StatelessWidget {
  const WhatTheCourseConvers({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What the Course Covers',
          style: textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        GapSizes.xsGap,
        Text(
          'A comprehensive, step-by-step masterclass on building 2D action RPGs using Flutter and the Bonfire game engine.',
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
        GapSizes.largeGap,
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Curriculum Modules
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildModuleCard(
                        context,
                        stepNumber: '01',
                        icon: Icons.cloud_done_rounded,
                        accentColor: Colors.blueAccent,
                        title: 'Cloud-First Development Setup',
                        description:
                            'Launch your development environment directly in your browser with GitHub Codespaces. Learn how to run, debug, and preview Flutter games with zero local toolchain setup.',
                      ),
                      GapSizes.mediumGap,
                      _buildModuleCard(
                        context,
                        stepNumber: '02',
                        icon: Icons.map_rounded,
                        accentColor: Colors.greenAccent,
                        title: 'Tilemaps & World Building',
                        description:
                            'Import Tiled JSON maps into Bonfire, render multiple visual layers, configure collision geometry for walls and obstacles, and create layered parallax backgrounds.',
                      ),
                      GapSizes.mediumGap,
                      _buildModuleCard(
                        context,
                        stepNumber: '03',
                        icon: Icons.sports_esports_rounded,
                        accentColor: Colors.orangeAccent,
                        title: 'Player Component & Controls',
                        description:
                            'Build custom character components with 8-direction sprite sheet animations (idle and running). Integrate responsive virtual joysticks and keyboard controls.',
                      ),
                      GapSizes.mediumGap,
                      _buildModuleCard(
                        context,
                        stepNumber: '04',
                        icon: Icons.shield_rounded,
                        accentColor: Colors.purpleAccent,
                        title: 'Collisions, Combat & Mechanics',
                        description:
                            'Master precise collision detection, implement melee attacks, hitboxes, character life bars, enemy tracking, and interactive environment items.',
                      ),
                      GapSizes.mediumGap,
                      _buildModuleCard(
                        context,
                        stepNumber: '05',
                        icon: Icons.rocket_launch_rounded,
                        accentColor: Colors.tealAccent,
                        title: 'Game Loop, Polish & Deployment',
                        description:
                            'Fine-tune the game loop, camera follow physics, lighting effects, sound integration, and export your finished game for Web, Desktop, and Mobile.',
                      ),
                    ],
                  ),
                ),
                GapSizes.largeGap,
                // Right Column: Project Showcase & Takeaways
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Project Spotlight Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.blueAccent.withValues(alpha: 0.3),
                          ),
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
                                  Icons.star_rounded,
                                  color: Colors.amberAccent,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "What You'll Build",
                                  style: textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            GapSizes.smallGap,
                            Text(
                              'By the end of this course, you will have constructed a playable 2D Action Adventure RPG featuring interactive maps, fluid character movement, and enemy mechanics.',
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                height: 1.5,
                              ),
                            ),
                            GapSizes.mediumGap,
                            const Center(
                              child: BonfireLottie(height: 160),
                            ),
                            GapSizes.mediumGap,
                            _buildChecklistItem(
                              context,
                              'Tiled map integration with full collision detection',
                            ),
                            _buildChecklistItem(
                              context,
                              '8-directional animated sprites and movement',
                            ),
                            _buildChecklistItem(
                              context,
                              'Parallax multi-layer scenic backgrounds',
                            ),
                            _buildChecklistItem(
                              context,
                              'Clean, extensible Flutter & Flame architecture',
                            ),
                          ],
                        ),
                      ),
                      GapSizes.mediumGap,
                      // Pro Tip Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Colors.amberAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Every lesson is designed to be modular. You can follow sequentially or jump directly to specific topics like map loading or joystick setup.',
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required String stepNumber,
    required IconData icon,
    required Color accentColor,
    required String title,
    required String description,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      stepNumber,
                      style: textTheme.labelSmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(BuildContext context, String text) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Colors.greenAccent,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
