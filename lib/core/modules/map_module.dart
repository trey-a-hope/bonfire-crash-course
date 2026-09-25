part of '_modules.dart';

const MAP_MODULE = Module(
  moduleName: 'Map',
  totalSteps: 4,
  completionHeadline: 'Map & World Complete!',
  completionSubtitle:
      'You successfully loaded a 2D tilemap, added animated parallax backgrounds, and configured viewport boundaries.',
  badgeText: 'MAP ARCHITECT',
  badgeIcon: Icons.map_rounded,
  accentColor: Colors.deepOrangeAccent,
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
