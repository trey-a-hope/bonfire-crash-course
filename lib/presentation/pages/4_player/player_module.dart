import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/lotties/enemy_lottie.dart';
import 'package:flutter/material.dart';

const PLAYER_MODULE = Module(
  totalSteps: 6,
  moduleName: 'Player',
  completionHeadline: 'Player Character Ready!',
  completionSubtitle:
      'Your hero is now fully assembled, animated, responding to keyboard controls, and ready to fight.',
  badgeText: 'HERO CONTROLLER',
  badgeIcon: Icons.person_rounded,
  accentColor: Colors.cyanAccent,
  achievements: [
    MilestoneAchievement(
      icon: Icons.directions_run_rounded,
      title: 'Sprite Animations',
      description:
          'Created smooth idle, walking, and action sprite animations.',
    ),
    MilestoneAchievement(
      icon: Icons.sports_esports_rounded,
      title: 'Fluid Controls',
      description:
          'Wired A/D movement, Space double jumps, and W/S attacks to the keyboard.',
    ),
    MilestoneAchievement(
      icon: Icons.center_focus_strong_rounded,
      title: 'Target Tracking',
      description:
          'Locked the camera viewport to smoothly follow player movement.',
    ),
    MilestoneAchievement(
      icon: Icons.shield_rounded,
      title: 'Collision Hitbox',
      description:
          'Configured precision hitboxes to interact with map obstacles.',
    ),
    MilestoneAchievement(
      icon: Icons.flash_on_rounded,
      title: 'Combat Ready',
      description:
          'Armed the hero with a melee strike and a projectile attack.',
    ),
  ],
  nextLottie: EnemyLottie(height: 100),
  nextModuleTitle: 'NPC (Allies)',
  nextModuleDescription:
      'Add a friendly companion that talks to the hero when they come close, waves hello, and then follows them around.',
);
