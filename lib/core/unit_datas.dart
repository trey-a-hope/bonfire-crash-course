import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';
import 'package:bonfire_crash_course/domain/models/unit_data.dart';
import 'package:flutter/material.dart';

enum UnitType { map, player, bonfireCrashCourse }

class UnitDatas {
  static const bonfireCrashCourseUnitData = UnitData(
    headline: 'Crash Course Completed!',
    subtitle:
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
    nextUnitTitle: 'Your Next Adventure',
    nextUnitDescription:
        'Experiment with custom weapons, boss AI, sound effects, and ship your own unique game!',
  );
  static const playerUnitData = UnitData(
    headline: 'Player Character Ready!',
    subtitle:
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
    nextUnitTitle: 'Enemies, Combat & NPC AI',
    nextUnitDescription:
        'Build enemy behavior trees, line-of-sight tracking, and attack mechanics.',
  );
  static const mapUnitData = UnitData(
    headline: 'Map & World Complete!',
    subtitle:
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
    nextUnitTitle: 'The Player Character',
    nextUnitDescription:
        'Configure spritesheets, idle/run animations, virtual joystick controls, and camera follow.',
  );
}
