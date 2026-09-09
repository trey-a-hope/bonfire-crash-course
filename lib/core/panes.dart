import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:bonfire_crash_course/presentation/pages/getting_started_page.dart';
import 'package:bonfire_crash_course/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';

final List<PaneInfo> panes = [
  // Welcome
  const PaneInfo(
    icon: Icon(Icons.home),
    title: 'Welcome',
    child: WelcomePage(),
  ),

  // Getting Started
  const PaneInfo(
    icon: Icon(Icons.open_in_browser),
    title: 'Getting Started',
    child: GettingStartedPage(),
  ),

  // Map
  const PaneInfo(
    icon: Icon(Icons.map),
    title: 'Map',
    children: [
      PaneInfo(
        icon: Icon(Icons.map_outlined),
        title: 'Tiled',
        child: Placeholder(color: Colors.green),
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
        title: 'Simple Player',
        child: Placeholder(color: Colors.green),
      ),
      PaneInfo(
        icon: Icon(Icons.person_outline),
        title: 'Rotation Player',
        child: Placeholder(color: Colors.yellow),
      ),
      PaneInfo(
        icon: Icon(Icons.person_outline),
        title: 'Platform Player',
        child: Placeholder(color: Colors.white),
      ),
    ],
  ),
];
