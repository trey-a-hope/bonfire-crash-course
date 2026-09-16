import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/what_is_the_flame_engine.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/what_the_course_convers.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/what_you_will_need.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/create_a_codespace.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/create_account_on_github.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/install_vscode.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/run_app.dart';
import 'package:bonfire_crash_course/presentation/pages/congrats.dart';
import 'package:bonfire_crash_course/presentation/pages/3_map/_map.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/player_component.dart';
import 'package:flutter/material.dart';

final List<PaneInfo> panes = [
  // Introduction
  const PaneInfo(
    icon: Icon(Icons.home),
    title: 'Introduction',
    children: [
      PaneInfo(
        icon: Icon(Icons.home_outlined),
        title: 'What is Flame & Bonfire',
        child: WhatIsTheFlameEngine(),
      ),
      PaneInfo(
        icon: Icon(Icons.home_outlined),
        title: 'What The Course Covers',
        child: WhatTheCourseConvers(),
      ),
      PaneInfo(
        icon: Icon(Icons.home_outlined),
        title: 'What You Will Need',
        child: WhatYouWillNeed(),
      ),
    ],
  ),

  // Getting Started
  const PaneInfo(
    icon: Icon(Icons.open_in_browser),
    title: 'Getting Started',
    children: [
      PaneInfo(
        icon: Icon(Icons.open_in_browser_outlined),
        title: 'Create Account on Github',
        child: CreateAccountOnGithub(),
      ),
      PaneInfo(
        icon: Icon(Icons.open_in_browser_outlined),
        title: 'Create a Codespace',
        child: CreateACodespace(),
      ),
      PaneInfo(
        icon: Icon(Icons.open_in_browser_outlined),
        title: 'Install VSCode (Optional)',
        child: InstallVSCode(),
      ),
      PaneInfo(
        icon: Icon(Icons.open_in_browser_outlined),
        title: 'Run the App',
        child: RunApp(),
      ),
    ],
  ),

  // Map
  const PaneInfo(
    icon: Icon(Icons.map),
    title: 'Map',
    children: [
      PaneInfo(
        icon: Icon(Icons.map_outlined),
        title: 'Loading the Map',
        child: LoadingTheMap(),
      ),
      PaneInfo(
        icon: Icon(Icons.map_outlined),
        title: 'Apply a Custom Background',
        child: ApplyCustomBackground(),
      ),
      PaneInfo(
        icon: Icon(Icons.map_outlined),
        title: 'Congrats',
        child: CongratsPage(),
      ),
    ],
  ),

  // Player
  const PaneInfo(
    icon: Icon(Icons.person),
    title: 'Player',
    children: [
      PaneInfo(
        icon: Icon(Icons.person_outline),
        title: 'Creating the Player Component',
        child: PlayerComponentPage(),
      ),
      PaneInfo(
        icon: Icon(Icons.person_outline),
        title: 'Congrats',
        child: CongratsPage(),
      ),
    ],
  ),

  // Congrats
  const PaneInfo(
    icon: Icon(Icons.check_circle),
    title: 'Congrats',
    child: CongratsPage(),
  ),
];
