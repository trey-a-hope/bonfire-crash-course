import 'package:bonfire_crash_course/presentation/pages/4_player/_3_apply_collision_to_player.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_4_move_and_jump.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_5_map_boundaries_for_player.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_6_player_attack_system.dart';
import 'package:bonfire_crash_course/presentation/pages/6_final/bonfire_crash_course_module.dart';
import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/_introduction.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/_getting_started.dart';
import 'package:bonfire_crash_course/presentation/pages/3_map/_map.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_player.dart';
import 'package:bonfire_crash_course/presentation/pages/5_npc/_npc.dart';
import 'package:bonfire_crash_course/presentation/pages/module_completion_page.dart';
import 'package:bonfire_crash_course/presentation/pages/module_overview_page.dart';
import 'package:flutter/material.dart';

final List<PaneInfo> panes = [
  // Introduction
  const PaneInfo(
    icon: Icon(Icons.home),
    title: 'Introduction',
    path: '/intro',
    children: [
      PaneInfo(
        title: 'Introduction',
        path: '/intro/starting',
        child: Introduction(),
      ),
      PaneInfo(
        title: 'What The Course Covers',
        path: '/intro/what-the-course-covers',
        child: WhatTheCourseConvers(),
      ),
      PaneInfo(
        title: 'What You Will Need',
        path: '/intro/what-you-will-need',
        child: WhatYouWillNeed(),
      ),
    ],
  ),

  // Getting Started
  const PaneInfo(
    icon: Icon(Icons.open_in_browser),
    title: 'Getting Started',
    path: '/getting-started',
    children: [
      PaneInfo(
        title: 'Create Account on Github',
        path: '/getting-started/create-account-on-github',
        child: CreateAccountOnGithub(),
      ),
      PaneInfo(
        title: 'Create a Codespace',
        path: '/getting-started/create-a-codespace',
        child: CreateACodespace(),
      ),
      PaneInfo(
        title: 'Run the App',
        path: '/getting-started/run-app',
        child: RunApp(),
      ),
      PaneInfo(
        title: 'Getting Started Finished!',
        path: '/getting-started/congrats',
        child: ModuleCompletionPage(module: GETTING_STARTED_MODULE),
      ),
    ],
  ),

  // Map
  const PaneInfo(
    icon: Icon(Icons.map),
    title: 'Map',
    path: '/map',
    children: [
      PaneInfo(
        title: 'Map Overview',
        path: '/map/overview',
        child: ModuleOverviewPage(
          moduleNumber: 3,
          moduleName: 'Map',
          tagline: 'Build the game world',
          icon: Icons.map,
          accentColor: Colors.deepOrangeAccent,
          lessonCount: 2,
          firstLessonTitle: 'Loading the Map',
          diagramAsset: 'assets/images/module_diagrams/module_3_map.svg',
        ),
      ),
      PaneInfo(
        title: 'Loading the Map',
        path: '/map/loading-the-map',
        child: LoadingTheMap(),
      ),
      PaneInfo(
        title: 'Create Parallax Background',
        path: '/map/create-parallax-background',
        child: CreateParallaxBackground(),
      ),
      PaneInfo(
        title: 'Add Parallax Background',
        path: '/map/add-parallax-background',
        child: AddParallaxBackground(),
      ),
      PaneInfo(
        title: 'Map Finished!',
        path: '/map/congrats',
        child: ModuleCompletionPage(module: MAP_MODULE),
      ),
    ],
  ),

  // Player
  const PaneInfo(
    icon: Icon(Icons.person),
    title: 'Hero (Player)',
    path: '/player',
    children: [
      PaneInfo(
        title: 'Player Overview',
        path: '/player/overview',
        child: ModuleOverviewPage(
          moduleNumber: 4,
          moduleName: 'Player',
          tagline: 'Build and control the hero',
          icon: Icons.person,
          accentColor: Colors.cyanAccent,
          lessonCount: 6,
          firstLessonTitle: 'Creating the Player Component',
          diagramAsset: 'assets/images/module_diagrams/module_4_player.svg',
        ),
      ),
      PaneInfo(
        title: 'Creating the Player Component',
        path: '/player/player-component',
        child: CreatePlayerComponentPage(),
      ),
      PaneInfo(
        title: 'Apply Gravity to Player',
        path: '/player/apply-gravity-to-player',
        child: ApplyGravityToPlayerPage(),
      ),
      PaneInfo(
        title: 'Apply Collision to Player',
        path: '/player/apply-collision-to-player',
        child: ApplyCollisionToPlayerPage(),
      ),
      PaneInfo(
        title: 'Move and Jump',
        path: '/player/move-and-jump',
        child: MoveAndJumpPage(),
      ),
      PaneInfo(
        title: 'Map Boundaries for Player',
        path: '/player/map-boundaries-for-player',
        child: MapBoundariesForPlayerPage(),
      ),
      PaneInfo(
        title: 'Player Attack System',
        path: '/player/player-attack-system',
        child: PlayerAttackSystemPage(),
      ),
      PaneInfo(
        title: 'Player Finished!',
        path: '/player/congrats',
        child: ModuleCompletionPage(module: PLAYER_MODULE),
      ),
    ],
  ),

  // NPC
  const PaneInfo(
    icon: Icon(Icons.help),
    title: 'Companion (Ally)',
    path: '/npc',
    children: [
      PaneInfo(
        title: 'NPC Overview',
        path: '/npc/overview',
        child: ModuleOverviewPage(
          moduleNumber: 5,
          moduleName: 'NPC (Ally)',
          tagline: 'Add a friendly character',
          icon: Icons.help,
          accentColor: Colors.purpleAccent,
          lessonCount: 6,
          firstLessonTitle: 'Creating the Companion Component',
          diagramAsset: 'assets/images/module_diagrams/module_5_npc_ally.svg',
        ),
      ),
      PaneInfo(
        title: 'Creating the Companion Component',
        path: '/npc/companion-component',
        child: CreateCompanionComponentPage(),
      ),
      PaneInfo(
        title: 'Companion Sprite Animations',
        path: '/npc/companion-sprite-animations',
        child: CompanionSpriteAnimationsPage(),
      ),
      PaneInfo(
        title: 'Apply Gravity and Collision to Companion',
        path: '/npc/apply-gravity-and-collision-to-companion',
        child: ApplyGravityAndCollisionToCompanionPage(),
      ),
      PaneInfo(
        title: 'Companion Dialogue',
        path: '/npc/companion-dialogue',
        child: CompanionDialoguePage(),
      ),
      PaneInfo(
        title: 'Make Berry Wave and Follow the Hero',
        path: '/npc/companion-wave-and-follow',
        child: CompanionWaveAndFollowPage(),
      ),
      PaneInfo(
        title: 'Berry\'s First-Meeting Cutscene',
        path: '/npc/companion-cutscene',
        child: CompanionCutscenePage(),
      ),
      PaneInfo(
        title: 'NPC Finished!',
        path: '/ally/congrats',
        child: ModuleCompletionPage(module: NPC_MODULE),
      ),
    ],
  ),

  // Enemy
  const PaneInfo(
    icon: Icon(Icons.help),
    title: 'Foe (Enemy)',
    path: '/enemy',
    children: [
      PaneInfo(
        title: 'Creating the Enemy Component',
        path: '/enemy/enemy-component',
        child: Placeholder(color: Colors.red),
      ),
      PaneInfo(
        title: 'Enemy Finished!',
        path: '/enemy/congrats',
        child: Placeholder(color: Colors.green),
      ),
    ],
  ),

  // Congrats
  const PaneInfo(
    icon: Icon(Icons.check_circle),
    title: 'Bonfire Crash Course Finished!',
    path: '/congrats',
    child: ModuleCompletionPage(module: BONFIRE_CRASH_COURSE),
  ),
];
