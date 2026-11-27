import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/lotties/bonfire_lottie.dart';
import 'package:material_ui/material_ui.dart';

const NPC_MODULE = Module(
  totalSteps: 6,
  moduleName: 'NPC (Ally)',
  completionHeadline: 'NPC Companion Ready!',
  completionSubtitle: 'Your companion now stands on the map, animates, collides with the world, talks to the hero in a short camera-pan cutscene, waves hello, and follows them around.',
  badgeText: 'COMPANION ARCHITECT',
  badgeIcon: Icons.smart_toy_rounded,
  accentColor: Colors.purpleAccent,
  achievements: [
    MilestoneAchievement(
      icon: Icons.person_add_rounded,
      title: 'Berry joins the world',
      description:
          'Your companion stands on the map, animates and stops at walls.',
    ),
    MilestoneAchievement(
      icon: Icons.chat_bubble_rounded,
      title: 'Talks and waves',
      description: 'When the hero comes close, the camera pans to Berry, a dialogue opens and Berry waves hello.',
    ),
    MilestoneAchievement(
      icon: Icons.directions_walk_rounded,
      title: 'Follows the hero',
      description:
          'After the first talk, Berry follows the hero around the map.',
    ),
  ],
  nextLottie: BonfireLottie(height: 100),
  nextModuleTitle: 'Course Finale & Publishing',
  nextModuleDescription: 'Package your 2D game, polish sound and game loops, and get ready to deploy!',
);
