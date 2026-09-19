import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/presentation/extensions/pane_info_extensions.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_modal_service.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_index_widget.dart';
import 'package:bonfire_crash_course/presentation/widgets/sheet_views/_sheet_views.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:signals/signals_flutter.dart';

/// The primary desktop window shell for the application.
///
/// Implements a responsive split-view desktop layout adapted to the host platform:
/// - On macOS: Renders a [MacosWindow] with a native [Sidebar].
/// - On Windows: Renders a [NavigationView] with a Fluent UI [NavigationPane].
///
/// Reactively observes [PageIndexController.index] via [SignalStatefulWidget] to update
/// sidebar selection and swap lesson content on the left panel, while preserving the
/// live [CodespaceWebView] editor session on the right.
class AdaptiveWindow extends SignalStatefulWidget {
  final StatefulNavigationShell navigationShell;

  /// Creates the [AdaptiveWindow] shell widget.
  const AdaptiveWindow({super.key, required this.navigationShell});

  @override
  State<AdaptiveWindow> createState() => _AdaptiveWindowState();
}

/// State implementation managing platform-adaptive navigation and layout.
class _AdaptiveWindowState extends State<AdaptiveWindow> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final macosSidebar = macos.Sidebar(
      top: Text(
        'Overview',
        style: textTheme.titleLarge!.copyWith(color: Colors.white),
      ),
      bottom: macos.MacosListTile(
        leading: const Icon(CupertinoIcons.settings, color: Colors.yellow),
        title: Text(
          'Settings',
          style: macos.MacosTheme.of(context).typography.headline,
        ),
        subtitle: Text(
          'Configure application settings',
          style: macos.MacosTheme.of(context).typography.subheadline.copyWith(
            color: macos.MacosColors.systemGrayColor,
          ),
        ),
        onClick: () =>
            AdaptiveModalService.showSheet(context, SheetType.settings),
      ),
      isResizable: false,
      dragClosed: false,
      minWidth: 275,
      builder: (context, scrollController) => macos.SidebarItems(
        items: panes.toSidebarItems(),
        currentIndex: widget.navigationShell.currentIndex,
        onChanged: _onChanged,
      ),
    );

    final windowsPane = NavigationPane(
      toggleButton: null,
      selected: widget.navigationShell.currentIndex,
      onChanged: _onChanged,
      displayMode: PaneDisplayMode.expanded,
      header: const Text('Bonfire Crash Course'),
      items: panes.toNavigationPaneItems(),
      footerItems: [
        PaneItemSeparator(),
        PaneItemAction(
          icon: const WindowsIcon(WindowsIcons.settings),
          title: const Text('Settings'),
          onTap: () async =>
              AdaptiveModalService.showSheet(context, SheetType.settings),
        ),
      ],
    );

    // Redundant IndexedStack is removed!
    // Simply render navigationShell + your persistent bottom widget:
    final content = Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: widget.navigationShell,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 32.0),
          child: PageIndexWidget(navigationShell: widget.navigationShell),
        ),
      ],
    );

    if (PlatformResolver.isWindows) {
      // Windows / Fluent UI navigation pane
      return NavigationView(
        pane: windowsPane,
        paneBodyBuilder: (item, body) => content,
      );
    } else {
      // macOS sidebar
      return macos.MacosWindow(sidebar: macosSidebar, child: content);
    }
  }

  /// Handles navigation pane selection changes across platforms.
  void _onChanged(int val) => widget.navigationShell.goBranch(
    val,
    initialLocation: val == widget.navigationShell.currentIndex,
  );
}
