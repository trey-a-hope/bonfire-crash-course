import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/lotties/map_lottie.dart';
import 'package:material_ui/material_ui.dart';

const GETTING_STARTED_MODULE = Module(
  moduleName: 'Getting Started',
  totalSteps: 4,
  completionHeadline: 'Environment Ready!',
  completionSubtitle: 'Great start! Your development workspace is set up and ready for 2D game creation in Flutter.',
  badgeText: 'ENVIRONMENT READY',
  badgeIcon: Icons.terminal_rounded,
  accentColor: Colors.lightGreenAccent,
  achievements: [
    MilestoneAchievement(
      icon: Icons.person_rounded,
      title: 'GitHub account ready',
      description: 'Your free key to the course template and the cloud editor.',
    ),
    MilestoneAchievement(
      icon: Icons.cloud_done_rounded,
      title: 'Codespace set up',
      description: "VS Code and Flutter in your browser. Stop it when you're done to save your free hours.",
    ),
    MilestoneAchievement(
      icon: Icons.play_circle_rounded,
      title: 'Starter game running',
      description: 'You ran the starter game on port 8080. Press r in the terminal to hot reload.',
    ),
  ],
  nextLottie: MapLottie(height: 100),
  nextModuleTitle: 'Building the World Map',
  nextModuleDescription: 'Import tilemaps, render interactive terrain, and configure dynamic parallax scenery.',
);
