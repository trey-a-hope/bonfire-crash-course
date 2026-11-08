import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/lotties/player_lottie.dart';
import 'package:flutter/material.dart';

const BONFIRE_CRASH_COURSE = Module(
  totalSteps: 4,
  moduleName: 'Bonfire Crash Course',
  completionHeadline: 'Crash Course Completed!',
  completionSubtitle:
      'Outstanding dedication! You have mastered the Bonfire game engine and built a complete 2D game in Flutter.',
  badgeText: 'BONFIRE CHAMPION',
  badgeIcon: Icons.emoji_events_rounded,
  accentColor: Colors.amberAccent,
  achievements: [
    MilestoneAchievement(
      icon: Icons.sports_esports_rounded,
      title: 'A complete 2D game',
      description:
          'Map, hero, companion and enemy all running together in Flutter with Bonfire.',
    ),
    MilestoneAchievement(
      icon: Icons.extension_rounded,
      title: 'Patterns you can reuse',
      description:
          'Components, sprite sheets, collision and cutscenes work the same way in your next game.',
    ),
    MilestoneAchievement(
      icon: Icons.rocket_launch_rounded,
      title: 'Ready to ship',
      description:
          'Flutter builds your game for web, desktop and mobile from the same code.',
    ),
  ],
  nextLottie: PlayerLottie(height: 100),
  nextModuleTitle: 'Your Next Adventure',
  nextModuleDescription:
      'Experiment with custom weapons, boss AI, sound effects, and ship your own unique game!',
);
