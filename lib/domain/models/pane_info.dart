import 'package:flutter/material.dart';

/// Represents a hierarchical navigation entry in the application's desktop sidebar.
///
/// Used to construct platform-adaptive navigation items for both Windows
/// (Fluent UI `NavigationPaneItem`) and macOS (`SidebarItem`), supporting
/// top-level pages as well as nested sub-sections.
class PaneInfo {
  /// The leading icon displayed alongside the navigation item.
  final Widget? icon;

  /// The label displayed in the sidebar navigation pane.
  final String title;

  /// The screen or view rendered when this navigation item is selected.
  ///
  /// Can be `null` if this item acts purely as a parent container with [children].
  final Widget? child;

  /// The route path for this navigation item in GoRouter (e.g. `/intro/what-is-flame`).
  final String path;

  /// Nested child navigation items grouped beneath this entry.
  final List<PaneInfo> children;

  /// Whether this navigation section should be expanded by default in the sidebar.
  final bool initiallyExpanded;

  /// Creates a new [PaneInfo] navigation item.
  const PaneInfo({
    this.icon,
    required this.title,
    this.child,
    required this.path,
    this.children = const [],
    this.initiallyExpanded = false,
  });

  /// Indicates whether this item contains nested sub-items.
  bool get isParent => children.isNotEmpty;
}
