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

  /// Course progress for the shell's current branch, from 0 to 100.
  ///
  /// It reaches 100 on the last pane, "Bonfire Crash Course Finished!".
  static double progress(StatefulNavigationShell shell) {
    final currentIndex = shell.currentIndex;
    final total = screens.length - 1;

    // As a fraction between 0.0 and 1.0 (ideal for LinearProgressIndicator):
    double progress = total > 0 ? currentIndex / total : 0.0; // 0.5

    // As a percentage value (0 to 100):
    double percentage = progress * 100; // 50.0

    // Formatted as a string:
    return percentage;
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
