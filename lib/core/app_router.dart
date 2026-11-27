import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/pages/miscellaneous/course_info/course_info_page.dart';
import 'package:bonfire_crash_course/presentation/pages/miscellaneous/settings_page.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/desktop_scaffold.dart';
import 'package:material_ui/material_ui.dart';
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

    // Settings sits outside the course shell so it does not count toward progress
    GoRoute(
      path: SettingsPage.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsPage(),
    ),

    // Course Info (the Content Outline and the starter project tour) is a
    // reference page, also outside progress
    GoRoute(
      path: CourseInfoPage.path,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CourseInfoPage(),
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
