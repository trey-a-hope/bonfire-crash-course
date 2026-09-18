import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/what_is_the_flame_engine.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/what_the_course_convers.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/what_you_will_need.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/create_a_codespace.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/create_account_on_github.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/install_vscode.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/run_app.dart';
import 'package:bonfire_crash_course/presentation/pages/unit_completion_page.dart';
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
        icon: Icon(Icons.home_outlined),
        title: 'What is Flame & Bonfire',
        path: '/intro/what-is-flame-and-bonfire',
        child: WhatIsTheFlameEngine(),
      ),
      PaneInfo(
        icon: Icon(Icons.home_outlined),
        title: 'What The Course Covers',
        path: '/intro/what-the-course-covers',
        child: WhatTheCourseConvers(),
      ),
      PaneInfo(
        icon: Icon(Icons.home_outlined),
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
        icon: Icon(Icons.open_in_browser_outlined),
        title: 'Create Account on Github',
        path: '/getting-started/create-account-on-github',
        child: CreateAccountOnGithub(),
      ),
      PaneInfo(
        icon: Icon(Icons.open_in_browser_outlined),
        title: 'Create a Codespace',
        path: '/getting-started/create-a-codespace',
        child: CreateACodespace(),
      ),
      PaneInfo(
        icon: Icon(Icons.open_in_browser_outlined),
        title: 'Install VSCode (Optional)',
        path: '/getting-started/install-vscode',
        child: InstallVSCode(),
      ),
      PaneInfo(
        icon: Icon(Icons.open_in_browser_outlined),
        title: 'Run the App',
        path: '/getting-started/run-app',
        child: RunApp(),
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
        icon: Icon(Icons.map_outlined),
        title: 'Loading the Map',
        path: '/map/loading-the-map',
        child: LoadingTheMap(),
      ),
      PaneInfo(
        icon: Icon(Icons.map_outlined),
        title: 'Apply a Custom Background',
        path: '/map/apply-a-custom-background',
        child: ApplyCustomBackground(),
      ),
      PaneInfo(
        icon: Icon(Icons.map_outlined),
        title: 'Map Finished!',
        path: '/map/congrats',
        child: UnitCompletionPage(unitName: 'Map'),
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
        icon: Icon(Icons.person_outline),
        title: 'Creating the Player Component',
        path: '/player/player-component',
        child: PlayerComponentPage(),
      ),
      PaneInfo(
        icon: Icon(Icons.person_outline),
        title: 'Player Finished!',
        path: '/player/congrats',
        child: UnitCompletionPage(unitName: 'Player'),
      ),
    ],
  ),

  // Congrats
  const PaneInfo(
    icon: Icon(Icons.check_circle),
    title: 'Bonfire Crash Course Finished!',
    path: '/congrats',
    child: UnitCompletionPage(unitName: 'Bonfire Crash Course'),
  ),
];
