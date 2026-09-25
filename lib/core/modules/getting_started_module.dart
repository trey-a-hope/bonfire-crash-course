part of '_modules.dart';

const GETTING_STARTED_MODULE = Module(
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
