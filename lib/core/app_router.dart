import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/widgets/desktop_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Application-wide GoRouter configuration for the Bonfire Crash Course app.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: ProgressNavigationController.navigateablePanes.first.path,
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) =>
          ProgressNavigationController.navigateablePanes.first.path,
    ),

    // Redirect parent category paths to their first navigable child
    for (final parent in panes.where((p) => p.children.isNotEmpty))
      GoRoute(
        path: parent.path,
        redirect: (context, state) => parent.children.first.path,
      ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          DesktopScaffold(navigationShell: navigationShell),
      branches: ProgressNavigationController.navigateablePanes
          .map(
            (pane) => StatefulShellBranch(
              routes: [
                GoRoute(
                  path: pane.path,
                  name: pane.title,
                  builder: (context, state) => pane.child!,
                ),
              ],
            ),
          )
          .toList(),
    ),
  ],
);
