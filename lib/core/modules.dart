import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/lotties/_lotties.dart';
import 'package:flutter/material.dart';

enum ModuleType { gettingStarted, map, player, bonfireCrashCourse }

class Modules {
  // Getting Started
  static const GETTING_STARTED = Module(
    moduleName: 'Getting Started',
    totalSteps: 4,
    completionHeadline: 'Environment Ready!',
    completionSubtitle:
        'Great start! Your development workspace is set up and ready for 2D game creation in Flutter.',
    badgeText: 'ENVIRONMENT READY',
    badgeIcon: Icons.terminal_rounded,
    accentColor: Colors.lightGreenAccent,
    achievements: [
      MilestoneAchievement(
        icon: Icons.code_rounded,
        title: 'Developer Account',
        description:
            'Created and authenticated your GitHub workspace for cloud source control.',
      ),
      MilestoneAchievement(
        icon: Icons.cloud_done_rounded,
        title: 'Cloud Codespace',
        description:
            'Spun up a cloud-hosted development container configured with Flutter.',
      ),
      MilestoneAchievement(
        icon: Icons.build_circle_rounded,
        title: 'IDE Tooling',
        description:
            'Configured VS Code with Flutter and Dart tooling for seamless development.',
      ),
      MilestoneAchievement(
        icon: Icons.play_arrow_rounded,
        title: 'Project Bootstrapped',
        description:
            'Successfully launched and verified the Bonfire starter game loop.',
      ),
    ],
    nextLottie: MapLottie(height: 100),
    nextModuleTitle: 'Building the World Map',
    nextModuleDescription:
        'Import tilemaps, render interactive terrain, and configure dynamic parallax scenery.',
  );

  // Player
  static const PLAYER = Module(
    totalSteps: 4,
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
    ],
    nextLottie: EnemyLottie(height: 100),
    nextModuleTitle: 'Enemies, Combat & NPC AI',
    nextModuleDescription:
        'Build enemy behavior trees, line-of-sight tracking, and attack mechanics.',
  );

  // Map
  static const MAP = Module(
    moduleName: 'Map',
    totalSteps: 4,
    completionHeadline: 'Map & World Complete!',
    completionSubtitle:
        'You successfully loaded a 2D tilemap, added animated parallax backgrounds, and configured viewport boundaries.',
    badgeText: 'MAP ARCHITECT',
    badgeIcon: Icons.map_rounded,
    accentColor: Colors.amberAccent,
    achievements: [
      MilestoneAchievement(
        icon: Icons.layers_rounded,
        title: 'Tilemap Integration',
        description:
            'Parsed Spritefusion map data and rendered terrain & collidable grids.',
      ),
      MilestoneAchievement(
        icon: Icons.filter_hdr_rounded,
        title: 'Parallax Scenery',
        description:
            'Layered sky and cloud assets with auto-scrolling depth velocities.',
      ),
      MilestoneAchievement(
        icon: Icons.videocam_rounded,
        title: 'Camera Boundaries',
        description:
            'Clamped camera motion strictly inside the map bounds with zoom fitting.',
      ),
      MilestoneAchievement(
        icon: Icons.grid_on_rounded,
        title: 'World Physics',
        description:
            'Constructed collision obstacles to prevent characters from falling off.',
      ),
    ],
    nextLottie: PlayerLottie(height: 100),
    nextModuleTitle: 'The Player Character',
    nextModuleDescription:
        'Configure spritesheets, idle/run animations, virtual joystick controls, and camera follow.',
  );

  // Bonfire Crash Course
  static const BONFIRE_CRASH_COURSE = Module(
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
        icon: Icons.auto_awesome_rounded,
        title: 'Bonfire Engine Master',
        description:
            'Orchestrated Flame game loops, component hierarchies, and state management.',
      ),
      MilestoneAchievement(
        icon: Icons.public_rounded,
        title: 'World Architecture',
        description:
            'Crafted interactive tilemaps, dynamic parallax scenes, and camera rigs.',
      ),
      MilestoneAchievement(
        icon: Icons.bolt_rounded,
        title: 'Entity Dynamics',
        description:
            'Programmed animated player controls, physics boundaries, and game triggers.',
      ),
      MilestoneAchievement(
        icon: Icons.rocket_launch_rounded,
        title: 'Ready for Indie Publishing',
        description:
            'Equipped with tools and patterns to launch 2D indie titles across desktop, mobile, and web.',
      ),
    ],
    nextLottie: PlayerLottie(height: 100),
    nextModuleTitle: 'Your Next Adventure',
    nextModuleDescription:
        'Experiment with custom weapons, boss AI, sound effects, and ship your own unique game!',
  );
}
