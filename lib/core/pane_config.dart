import 'package:bonfire_crash_course/core/modules/_modules.dart';
import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/introduction.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/what_the_course_convers.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/what_you_will_need.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/create_a_codespace.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/create_account_on_github.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/install_vscode.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/run_app.dart';
import 'package:bonfire_crash_course/presentation/pages/5_npc/npc_component.dart';
import 'package:bonfire_crash_course/presentation/pages/module_completion_page.dart';
import 'package:bonfire_crash_course/presentation/pages/3_map/_map.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/player_component.dart';
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
    title: 'Player',
    path: '/player',
    children: [
      PaneInfo(
        title: 'Creating the Player Component',
        path: '/player/player-component',
        child: PlayerComponentPage(),
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
    title: 'NPC (Ally)',
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

  // Congrats
  const PaneInfo(
    icon: Icon(Icons.check_circle),
    title: 'Bonfire Crash Course Finished!',
    path: '/congrats',
    child: ModuleCompletionPage(module: BONFIRE_CRASH_COURSE),
  ),
];
