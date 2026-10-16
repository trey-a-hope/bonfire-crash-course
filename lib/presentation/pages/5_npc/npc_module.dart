import 'package:bonfire_crash_course/domain/models/milestone_achievement.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/lotties/bonfire_lottie.dart';
import 'package:flutter/material.dart';

const NPC_MODULE = Module(
  totalSteps: 5,
  moduleName: 'NPC (Ally)',
  completionHeadline: 'NPC Companion Ready!',
  completionSubtitle:
      'Your companion now stands on the map, animates, collides with the world, talks to the hero, waves hello, and follows them around.',
  badgeText: 'COMPANION ARCHITECT',
  badgeIcon: Icons.smart_toy_rounded,
  accentColor: Colors.purpleAccent,
  achievements: [
    MilestoneAchievement(
      icon: Icons.person_add_alt_1_rounded,
      title: 'NPC Component',
      description:
          'Extended SimpleAlly to build a friendly Companion that joins the game world.',
    ),
    MilestoneAchievement(
      icon: Icons.animation_rounded,
      title: 'Sprite Animations',
      description:
          'Gave the companion idle and walk animations from the strawberry sheets.',
    ),
    MilestoneAchievement(
      icon: Icons.shield_rounded,
      title: 'Hitbox & Collision',
      description:
          'Added gravity, collision and a hitbox so the companion stands on the map and blocks the hero.',
    ),
    MilestoneAchievement(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Dialogue & Interaction',
      description:
          'Used vision.seePlayer to open a TalkDialog when the hero comes close.',
    ),
    MilestoneAchievement(
      icon: Icons.directions_walk_rounded,
      title: 'Wave & Follow',
      description:
          'Played a one-shot wave with playOnceOther and made the companion follow the hero along the ground.',
    ),
  ],
  nextLottie: BonfireLottie(height: 100),
  nextModuleTitle: 'Course Finale & Publishing',
  nextModuleDescription:
      'Package your 2D game, polish sound and game loops, and get ready to deploy!',
);
