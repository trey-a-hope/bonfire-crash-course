import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/lotties/_lotties.dart';
import 'package:flutter/material.dart';

class _MilestoneAchievement {
  final IconData icon;
  final String title;
  final String description;

  const _MilestoneAchievement({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _UnitData {
  final String headline;
  final String subtitle;
  final String badgeText;
  final IconData badgeIcon;
  final Color accentColor;
  final List<_MilestoneAchievement> achievements;
  final String nextUnitTitle;
  final String nextUnitDescription;

  const _UnitData({
    required this.headline,
    required this.subtitle,
    required this.badgeText,
    required this.badgeIcon,
    required this.accentColor,
    required this.achievements,
    required this.nextUnitTitle,
    required this.nextUnitDescription,
  });
}

/// A visually rewarding completion screen displayed when a user finishes a curriculum unit.
///
/// Features animated celebration lotties, dynamic milestone badges, unlocked skill cards,
/// unit metrics, and a "Next Up" guidance banner.
class UnitCompletionPage extends StatelessWidget {
  final String unitName;

  const UnitCompletionPage({super.key, required this.unitName});

  _UnitData _getUnitData() {
    final normalized = unitName.toLowerCase().trim();

    if (normalized.contains('map')) {
      return const _UnitData(
        headline: 'Map & World Complete!',
        subtitle:
            'You successfully loaded a 2D tilemap, added animated parallax backgrounds, and configured viewport boundaries.',
        badgeText: 'MAP ARCHITECT',
        badgeIcon: Icons.map_rounded,
        accentColor: Colors.amberAccent,
        achievements: [
          _MilestoneAchievement(
            icon: Icons.layers_rounded,
            title: 'Tilemap Integration',
            description:
                'Parsed Spritefusion map data and rendered terrain & collidable grids.',
          ),
          _MilestoneAchievement(
            icon: Icons.filter_hdr_rounded,
            title: 'Parallax Scenery',
            description:
                'Layered sky and cloud assets with auto-scrolling depth velocities.',
          ),
          _MilestoneAchievement(
            icon: Icons.videocam_rounded,
            title: 'Camera Boundaries',
            description:
                'Clamped camera motion strictly inside the map bounds with zoom fitting.',
          ),
          _MilestoneAchievement(
            icon: Icons.grid_on_rounded,
            title: 'World Physics',
            description:
                'Constructed collision obstacles to prevent characters from falling off.',
          ),
        ],
        nextUnitTitle: 'The Player Character',
        nextUnitDescription:
            'Configure spritesheets, idle/run animations, virtual joystick controls, and camera follow.',
      );
    }

    if (normalized.contains('player')) {
      return const _UnitData(
        headline: 'Player Character Ready!',
        subtitle:
            'Your hero is now fully assembled, animated, and responding to real-time player controls.',
        badgeText: 'HERO CONTROLLER',
        badgeIcon: Icons.person_rounded,
        accentColor: Colors.cyanAccent,
        achievements: [
          _MilestoneAchievement(
            icon: Icons.directions_run_rounded,
            title: 'Sprite Animations',
            description:
                'Created smooth idle, walking, and action sprite animations.',
          ),
          _MilestoneAchievement(
            icon: Icons.sports_esports_rounded,
            title: 'Fluid Controls',
            description:
                'Wired virtual joysticks and keyboard inputs to movement vectors.',
          ),
          _MilestoneAchievement(
            icon: Icons.center_focus_strong_rounded,
            title: 'Target Tracking',
            description:
                'Locked the camera viewport to smoothly follow player movement.',
          ),
          _MilestoneAchievement(
            icon: Icons.shield_rounded,
            title: 'Collision Hitbox',
            description:
                'Configured precision hitboxes to interact with map obstacles.',
          ),
        ],
        nextUnitTitle: 'Enemies, Combat & NPC AI',
        nextUnitDescription:
            'Build enemy behavior trees, line-of-sight tracking, and attack mechanics.',
      );
    }

    if (normalized.contains('bonfire') || normalized.contains('crash course')) {
      return const _UnitData(
        headline: 'Crash Course Completed!',
        subtitle:
            'Outstanding dedication! You have mastered the Bonfire game engine and built a complete 2D game in Flutter.',
        badgeText: 'BONFIRE CHAMPION',
        badgeIcon: Icons.emoji_events_rounded,
        accentColor: Colors.amberAccent,
        achievements: [
          _MilestoneAchievement(
            icon: Icons.auto_awesome_rounded,
            title: 'Bonfire Engine Master',
            description:
                'Orchestrated Flame game loops, component hierarchies, and state management.',
          ),
          _MilestoneAchievement(
            icon: Icons.public_rounded,
            title: 'World Architecture',
            description:
                'Crafted interactive tilemaps, dynamic parallax scenes, and camera rigs.',
          ),
          _MilestoneAchievement(
            icon: Icons.bolt_rounded,
            title: 'Entity Dynamics',
            description:
                'Programmed animated player controls, physics boundaries, and game triggers.',
          ),
          _MilestoneAchievement(
            icon: Icons.rocket_launch_rounded,
            title: 'Ready for Indie Publishing',
            description:
                'Equipped with tools and patterns to launch 2D indie titles across desktop, mobile, and web.',
          ),
        ],
        nextUnitTitle: 'Your Next Adventure',
        nextUnitDescription:
            'Experiment with custom weapons, boss AI, sound effects, and ship your own unique game!',
      );
    }

    // Default fallback
    return _UnitData(
      headline: '$unitName Conquered!',
      subtitle:
          'Great job! You have successfully completed all lessons and coding checkpoints in this unit.',
      badgeText: '${unitName.toUpperCase()} MASTER',
      badgeIcon: Icons.military_tech_rounded,
      accentColor: Colors.blueAccent,
      achievements: const [
        _MilestoneAchievement(
          icon: Icons.verified_rounded,
          title: 'Core Concepts',
          description:
              'Understood architectural principles and Bonfire API patterns.',
        ),
        _MilestoneAchievement(
          icon: Icons.code_rounded,
          title: 'Hands-on Code',
          description:
              'Implemented working game components in Flutter and Flame.',
        ),
        _MilestoneAchievement(
          icon: Icons.check_circle_outline_rounded,
          title: 'Validated Checkpoints',
          description: 'Tested and verified mechanics inside the running game.',
        ),
      ],
      nextUnitTitle: 'Next Unit',
      nextUnitDescription:
          'Click Next in the bottom navigation bar to advance to the next exciting topic.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final unitData = _getUnitData();

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
                          unitData.accentColor.withValues(alpha: 0.28),
                          unitData.accentColor.withValues(alpha: 0.08),
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
                  color: unitData.accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: unitData.accentColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      unitData.badgeIcon,
                      color: unitData.accentColor,
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      unitData.badgeText,
                      style: textTheme.labelMedium?.copyWith(
                        color: unitData.accentColor,
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
                unitData.headline,
                textAlign: TextAlign.center,
                style: textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Text(
                  unitData.subtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ),
              GapSizes.mediumGap,

              // 4. Milestone Metrics Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      icon: Icons.check_circle_rounded,
                      color: Colors.greenAccent,
                      title: '100% Complete',
                      subtitle: 'All checkpoints passed',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      icon: Icons.workspace_premium_rounded,
                      color: unitData.accentColor,
                      title: 'Milestone Achieved',
                      subtitle: 'Skill badge earned',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricCard(
                      context,
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
                    const SizedBox(width: 16),
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
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.blueAccent,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                unitData.nextUnitTitle,
                                style: textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            unitData.nextUnitDescription,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blueAccent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Click Next',
                            style: textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildMetricCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
