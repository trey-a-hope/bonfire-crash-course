import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/lotties/player_lottie.dart';
import 'package:material_ui/material_ui.dart';

/// The Map module (module 3): its step count for the "STEP X OF N" badge and
/// its completion page content.
///
/// [Module.totalSteps] matches the module's three lessons in
/// `lib/core/pane_config.dart` (Loading the Map, Create Parallax Background,
/// Add Parallax Background).
const MAP_MODULE = Module(
  moduleName: 'Map',
  totalSteps: 3,
  completionHeadline: 'Map & World Complete!',
  completionSubtitle:
      'You successfully loaded a 2D tilemap, added animated parallax backgrounds, and configured viewport boundaries.',
  badgeText: 'MAP ARCHITECT',
  badgeIcon: Icons.map_rounded,
  accentColor: Colors.deepOrangeAccent,
  achievements: [
    MilestoneAchievement(
      icon: Icons.layers_rounded,
      title: 'Map loaded',
      description:
          'Your Sprite Fusion tilemap draws the ground, and its collision tiles keep everyone from falling through.',
    ),
    MilestoneAchievement(
      icon: Icons.landscape_rounded,
      title: 'Parallax sky',
      description:
          'Sky and cloud layers scroll at different speeds behind the map for depth.',
    ),
    MilestoneAchievement(
      icon: Icons.videocam_rounded,
      title: 'Camera inside the map',
      description:
          'The camera stays within the map edges and zooms to fit the screen.',
    ),
  ],
  nextLottie: PlayerLottie(height: 100),
  nextModuleTitle: 'The Player Character',
  nextModuleDescription:
      'Animate a hero sprite, add gravity and collision, and wire up keyboard movement, jumping, and attacks.',
);
