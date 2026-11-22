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
  ///
  /// From the "Bonfire Crash Course Finished!" page this opens the first
  /// Content Outline page, which comes after it in `pane_config.dart`.
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
  static double progress(StatefulNavigationShell shell) =>
      progressAt(shell.currentIndex);

  /// Course progress, from 0 to 100, for the pane at [index] in
  /// [navigateablePanes].
  ///
  /// It reaches 100 on the last course page ("Bonfire Crash Course
  /// Finished!"). The Content Outline pages after it are a review, not part
  /// of the course, so they also read 100 instead of pushing the finish page
  /// below it.
  static double progressAt(int index) {
    final total = courseEndIndex;
    if (total <= 0) return 0.0;
    return (index / total).clamp(0.0, 1.0) * 100;
  }

  /// Index in [navigateablePanes] of the last page that counts toward
  /// progress: the last pane before the Content Outline section.
  static int get courseEndIndex {
    final panes = navigateablePanes;
    final firstOutline = panes.indexWhere(
      (pane) => pane.path.startsWith('$contentOutlinePath/'),
    );
    return (firstOutline == -1 ? panes.length : firstOutline) - 1;
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
