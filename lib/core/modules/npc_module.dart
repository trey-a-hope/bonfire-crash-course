part of '_modules.dart';

const NPC_MODULE = Module(
  totalSteps: 4,
  moduleName: 'NPC (Ally)',
  completionHeadline: 'NPC Companion Ready!',
  completionSubtitle:
      'Your ally NPC is now fully configured with custom sprites, collision physics, and interactive behaviors.',
  badgeText: 'COMPANION ARCHITECT',
  badgeIcon: Icons.smart_toy_rounded,
  accentColor: Colors.purpleAccent,
  achievements: [
    MilestoneAchievement(
      icon: Icons.person_add_alt_1_rounded,
      title: 'NPC Component',
      description:
          'Extended SimpleNpc to build an interactive non-player character component.',
    ),
    MilestoneAchievement(
      icon: Icons.animation_rounded,
      title: 'Sprite Animations',
      description:
          'Configured idle and movement animation sheets for the ally.',
    ),
    MilestoneAchievement(
      icon: Icons.shield_rounded,
      title: 'Hitbox & Collision',
      description:
          'Attached boundary hitboxes to enable world and player collisions.',
    ),
    MilestoneAchievement(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Dialogue & Interaction',
      description:
          'Implemented proximity triggers for player interaction and speech bubbles.',
    ),
  ],
  nextLottie: BonfireLottie(height: 100),
  nextModuleTitle: 'Course Finale & Publishing',
  nextModuleDescription:
      'Package your 2D game, polish sound and game loops, and get ready to deploy!',
);
