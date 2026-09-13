import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:bonfire_crash_course/presentation/pages/map/_map.dart';
import 'package:bonfire_crash_course/presentation/pages/player/player_component.dart';
import 'package:signals/signals_flutter.dart';
import 'package:bonfire_crash_course/presentation/pages/getting_started_page.dart';
import 'package:bonfire_crash_course/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';

/// A controller managing the active page/screen navigation index across the app.
///
/// Uses [Signal] to provide reactive state management, keeping navigation elements
/// like sidebars and next/previous page controls in sync.
class PageIndexController {
  /// The reactive signal holding the current page index.
  static final Signal<int> _index = signal(
    0,
    options: SignalOptions(name: 'PageIndexController.index'),
  );

  /// Gets the current active page index.
  static int get index => _index.value;

  /// Sets the active page index to [value].
  static set index(int value) => _index.value = value;

  /// Advances to the next page index.
  static void increment() {
    if (_index.value < screens.length - 1) _index.value++;
  }

  /// Navigates back to the previous page index.
  static void decrement() {
    if (_index.value > 0) _index.value--;
  }

  /// The list of screens to navigate through.
  static List<Widget> get screens => _extractScreens(panes);

  /// Recursively extract only items that have content/screens
  static List<Widget> _extractScreens(List<PaneInfo> items) {
    final List<Widget> screens = [];
    for (final item in items) {
      if (item.child != null) {
        screens.add(item.child!);
      }
      if (item.children.isNotEmpty) {
        screens.addAll(_extractScreens(item.children));
      }
    }
    return screens;
  }
}

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
        title: 'Loading the Map',
        child: LoadingTheMap(),
      ),
      PaneInfo(
        icon: Icon(Icons.map_outlined),
        title: 'Apply a Custom Background',
        child: ApplyCustomBackground(),
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
    ],
  ),
];
