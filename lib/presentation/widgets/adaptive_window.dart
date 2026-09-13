import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/domain/controllers/page_index_controller.dart';
import 'package:bonfire_crash_course/presentation/extensions/pane_info_extensions.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_modal.dart';
import 'package:bonfire_crash_course/presentation/widgets/codespace_web_view.dart';
import 'package:bonfire_crash_course/presentation/widgets/sheet_views/_sheet_views.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  /// Creates the [AdaptiveWindow] shell widget.
  const AdaptiveWindow({super.key});

  @override
  State<AdaptiveWindow> createState() => _AdaptiveWindowState();
}

/// State implementation managing platform-adaptive navigation and layout.
class _AdaptiveWindowState extends State<AdaptiveWindow> {
  @override
  Widget build(BuildContext context) {
    final activeScreens = PageIndexController.screens;
    final showEditor = PageIndexController.index > 1;
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
      minWidth: 300,
      builder: (context, scrollController) => macos.SidebarItems(
        items: panes.toSidebarItems(),
        currentIndex: PageIndexController.index,
        onChanged: (newIndex) {
          if (newIndex < activeScreens.length) {
            PageIndexController.index = newIndex;
          }
        },
      ),
    );

    final windowsPane = NavigationPane(
      toggleButton: null,
      selected: PageIndexController.index,
      onChanged: (newIndex) => newIndex < activeScreens.length
          ? PageIndexController.index = newIndex
          : null,
      displayMode: PaneDisplayMode.auto,
      header: const Text('Bonfire Crash Course'),
      items: panes.toNavigationPaneItems(),
      footerItems: [
        PaneItemSeparator(),
        PaneItem(
          icon: const WindowsIcon(WindowsIcons.settings),
          title: const Text('Settings'),
          body: const SizedBox.shrink(),
          onTap: () async =>
              AdaptiveModalService.showSheet(context, SheetType.settings),
        ),
      ],
    );

    final codeEditor = Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: IndexedStack(
              index: PageIndexController.index,
              children: activeScreens,
            ),
          ),
          if (showEditor) ...[
            GapSizes.xlGap,
            const Flexible(flex: 2, child: CodespaceWebView()),
          ] else
            const SizedBox.shrink(),
        ],
      ),
    );

    if (PlatformResolver.isWindows) {
      // Windows / Fluent UI navigation pane
      return NavigationView(
        pane: windowsPane,
        paneBodyBuilder: (item, body) => codeEditor,
      );
    } else {
      // macOS sidebar
      return macos.MacosWindow(sidebar: macosSidebar, child: codeEditor);
    }
  }
}
