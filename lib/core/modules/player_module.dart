import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/lotties/enemy_lottie.dart';
import 'package:material_ui/material_ui.dart';

const PLAYER_MODULE = Module(
  totalSteps: 7,
  moduleName: 'Player',
  completionHeadline: 'Player Character Ready!',
  completionSubtitle: 'Your hero is now fully assembled, animated, responding to keyboard controls, and ready to fight.',
  badgeText: 'HERO CONTROLLER',
  badgeIcon: Icons.person_rounded,
  accentColor: Colors.cyanAccent,
  achievements: [
    MilestoneAchievement(
      icon: Icons.directions_run_rounded,
      title: 'Hero animated',
      description:
          'Idle, walk and attack animations play from the sprite sheets.',
    ),
    MilestoneAchievement(
      icon: Icons.sports_esports_rounded,
      title: 'Moves and jumps',
      description: 'A and D to move, Space to jump (twice for a double jump), with gravity and collision.',
    ),
    MilestoneAchievement(
      icon: Icons.flash_on_rounded,
      title: 'Ready to fight',
      description: 'W fires a magic bolt and S swings a melee strike.',
    ),
  ],
  nextLottie: EnemyLottie(height: 100),
  nextModuleTitle: 'NPC (Allies)',
  nextModuleDescription: 'Add a friendly companion that talks to the hero when they come close, waves hello, and then follows them around.',
);
