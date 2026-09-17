import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';
import 'package:flutter/material.dart';

/// A controller managing the active page/screen navigation index across the app.
///
/// Uses [Signal] to provide reactive state management, keeping navigation elements
/// like sidebars and next/previous page controls in sync.
class ProgressNavigationController {
  static void increment(StatefulNavigationShell shell) {
    if (shell.currentIndex < screens.length - 1) {
      shell.goBranch(shell.currentIndex + 1);
    }
  }

  static void decrement(StatefulNavigationShell shell) {
    if (shell.currentIndex > 0) {
      shell.goBranch(shell.currentIndex - 1);
    }
  }

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

  /// Recursively extract only items that have content/screens
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
