import 'package:bonfire_crash_course/presentation/pages/4_player/_3_apply_collision_to_player.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_4_move_and_jump.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_5_map_boundaries_for_player.dart';
import 'package:bonfire_crash_course/presentation/pages/6_final/bonfire_crash_course_module.dart';
import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/_introduction.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/_getting_started.dart';
import 'package:bonfire_crash_course/presentation/pages/3_map/_map.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_player.dart';
import 'package:bonfire_crash_course/presentation/pages/5_npc/_npc.dart';
import 'package:bonfire_crash_course/presentation/pages/module_completion_page.dart';
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
        title: 'Install VSCode (Optional)',
        path: '/getting-started/install-vscode',
        child: InstallVSCode(),
      ),
      PaneInfo(
        title: 'Project File Structure',
        path: '/getting-started/project-file-structure',
        child: ProjectFileStructure(),
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
        title: 'Loading the Map',
        path: '/map/loading-the-map',
        child: LoadingTheMap(),
      ),
      PaneInfo(
        title: 'Apply a Custom Background',
        path: '/map/apply-a-custom-background',
        child: ApplyCustomBackground(),
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
        title: 'Creating the NPC Component',
        path: '/npc/npc-component',
        child: NPCComponentPage(),
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
