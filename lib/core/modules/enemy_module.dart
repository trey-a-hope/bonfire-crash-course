import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/lotties/enemy_lottie.dart';
import 'package:material_ui/material_ui.dart';

/// The Enemy module (module 5): its step count for the "STEP X OF N" badge
/// and its completion page content.
///
/// [Module.totalSteps] matches the module's two lessons in
/// `lib/core/pane_config.dart` (Creating the Enemy Component, Apply
/// Behavior).
const ENEMY_MODULE = Module(
  totalSteps: 2,
  moduleName: 'Enemy',
  completionHeadline: 'Enemy Character Ready!',
  completionSubtitle:
      'Your enemy awaits you, it\'s time to show hime what you got!',
  badgeText: 'ENEMY THWARPER',
  badgeIcon: Icons.badge,
  accentColor: Colors.redAccent,
  achievements: [
    MilestoneAchievement(
      icon: Icons.directions_run_rounded,
      title: 'Enemy animated',
      description:
          'Idle, walk and attack animations play from the sprite sheets.',
    ),
    MilestoneAchievement(
      icon: Icons.sports_esports_rounded,
      title: 'Moves and jumps',
      description:
          'A and D to move, Space to jump (twice for a double jump), with gravity and collision.',
    ),
    MilestoneAchievement(
      icon: Icons.flash_on_rounded,
      title: 'Ready to fight',
      description: 'W fires a magic bolt and S swings a melee strike.',
    ),
  ],
  nextLottie: EnemyLottie(height: 100),
  nextModuleTitle: 'NPC (Allies)',
  nextModuleDescription:
      'Add a friendly companion that talks to the hero when they come close, waves hello, and then follows them around.',
);
