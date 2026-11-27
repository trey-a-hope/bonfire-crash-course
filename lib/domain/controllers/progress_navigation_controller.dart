import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';
import 'package:material_ui/material_ui.dart';

/// A controller managing the active page/screen navigation index across the app.
///
/// Uses [Signal] to provide reactive state management, keeping navigation elements
/// like sidebars and next/previous page controls in sync.
class ProgressNavigationController {
  /// Goes to the pane after the current one in [navigateablePanes], if any.
  static void next(BuildContext context) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final currentIndex = navigateablePanes.indexWhere(
      (pane) => pane.path == currentPath,
    );
    if (currentIndex != -1 && currentIndex < navigateablePanes.length - 1) {
      context.go(navigateablePanes[currentIndex + 1].path);
    }
  }

  /// Goes to the pane before the current one in [navigateablePanes], if any.
  static void previous(BuildContext context) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final currentIndex = navigateablePanes.indexWhere(
      (pane) => pane.path == currentPath,
    );
    if (currentIndex > 0) {
      context.go(navigateablePanes[currentIndex - 1].path);
    }
  }

  /// Path of the module where course progress starts counting.
  static const String _progressStartModulePath = '/getting-started';

  /// Index in [navigateablePanes] of the first lesson that counts toward
  /// progress: the first lesson of the Getting Started module. Panes before
  /// it (the Introduction) don't count, and progress is hidden on them.
  static int get progressStartIndex {
    final startModule = panes.firstWhere(
      (pane) => pane.path == _progressStartModulePath,
    );
    final firstLesson = _extractNavigateablePanes([startModule]).first;
    return navigateablePanes.indexOf(firstLesson);
  }

  /// Whether the shell's current branch is far enough into the course for
  /// progress to be shown, i.e. at or past [progressStartIndex].
  static bool isProgressVisible(StatefulNavigationShell shell) =>
      shell.currentIndex >= progressStartIndex;

  /// Course progress for the shell's current branch, from 0 to 100.
  ///
  /// It is 0 on the first Getting Started lesson (and on every pane before
  /// it) and reaches 100 on the last pane, "Bonfire Crash Course Finished!".
  static double progress(StatefulNavigationShell shell) {
    final start = progressStartIndex;
    final currentIndex = shell.currentIndex - start;
    final total = screens.length - 1 - start;

    // As a fraction between 0.0 and 1.0.
    final fraction = total > 0 ? (currentIndex / total).clamp(0.0, 1.0) : 0.0;

    // As a percentage value (0 to 100).
    return fraction * 100;
  }

  /// Flattened list of all pane items that have a screen (child != null).
  static List<PaneInfo> get navigateablePanes =>
      _extractNavigateablePanes(panes);

  /// The list of screens to navigate through.
  static List<Widget> get screens =>
      navigateablePanes.map((pane) => pane.child!).toList();

  /// Recursively extracts only the items that have content/screens, in
  /// sidebar order.
  static List<PaneInfo> _extractNavigateablePanes(List<PaneInfo> items) {
    final List<PaneInfo> result = [];
    for (final item in items) {
      if (item.child != null) {
        result.add(item);
      }
      if (item.children.isNotEmpty) {
        result.addAll(_extractNavigateablePanes(item.children));
      }
    }
    return result;
  }
}
