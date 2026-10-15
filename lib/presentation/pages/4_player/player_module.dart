import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/lotties/enemy_lottie.dart';
import 'package:flutter/material.dart';

const PLAYER_MODULE = Module(
  totalSteps: 6,
  moduleName: 'Player',
  completionHeadline: 'Player Character Ready!',
  completionSubtitle:
      'Your hero is now fully assembled, animated, and responding to real-time player controls.',
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
          'Wired virtual joysticks and keyboard inputs to movement vectors.',
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
          'Armed the hero with melee and ranged attacks and enemy vision.',
    ),
  ],
  nextLottie: EnemyLottie(height: 100),
  nextModuleTitle: 'NPC (Allies)',
  nextModuleDescription:
      'Build enemy behavior trees, line-of-sight tracking, and attack mechanics.',
);
