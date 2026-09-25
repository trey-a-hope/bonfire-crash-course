part of '_modules.dart';

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
