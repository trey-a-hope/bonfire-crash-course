import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:macos_ui/macos_ui.dart';

/// Extension methods for converting a list of [PaneInfo] into platform-specific
/// navigation items for macOS and Windows.
extension PaneInfoListX on List<PaneInfo> {
  /// Converts [PaneInfo] items into macOS [SidebarItem]s.
  List<SidebarItem> toSidebarItems() {
    return map(
      (e) => SidebarItem(
        leading: e.icon,
        label: Text(e.title),
        disclosureItems: e.children.isNotEmpty
            ? e.children.toSidebarItems()
            : null,
      ),
    ).toList();
  }

  /// Converts [PaneInfo] items into Windows Fluent [NavigationPaneItem]s.
  List<NavigationPaneItem> toNavigationPaneItems() {
    return map((item) {
      if (item.children.isNotEmpty) {
        return PaneItemExpander(
          icon: item.icon ?? const SizedBox.shrink(),
          title: Text(item.title),
          initiallyExpanded: true,
          items: item.children.toNavigationPaneItems(),
          body: item.child != null ? const SizedBox.shrink() : null,
        );
      }

      return PaneItem(
        icon: item.icon,
        title: Text(item.title),
        body: const SizedBox.shrink(),
      );
    }).toList();
  }
}
