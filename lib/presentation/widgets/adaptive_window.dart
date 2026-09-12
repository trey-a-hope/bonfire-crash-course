import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/domain/controllers/page_index_controller.dart';
import 'package:bonfire_crash_course/presentation/extensions/pane_info_extensions.dart';
import 'package:bonfire_crash_course/presentation/widgets/version_label.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:signals/signals_flutter.dart';

class AdaptiveWindow extends SignalStatefulWidget {
  const AdaptiveWindow({super.key});

  @override
  State<AdaptiveWindow> createState() => _AdaptiveWindowState();
}

/// A platform‑adaptive sidebar that shows a Fluent UI NavigationPane on
/// Windows and a macOS UI Sidebar on macOS.
class _AdaptiveWindowState extends State<AdaptiveWindow> {
  @override
  Widget build(BuildContext context) {
    final activeScreens = PageIndexController.screens;

    final textTheme = Theme.of(context).textTheme;

    final endSidebar = Sidebar(
      top: Text(
        'Live Chat',
        style: textTheme.titleLarge!.copyWith(color: Colors.white),
      ),
      isResizable: false,
      dragClosed: false,
      minWidth: 200,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MacosTextField(
              placeholder: 'Type some text here',
              maxLines: 25,
              maxLengthEnforcement: MaxLengthEnforcement.none,
            ),
          ],
        ),
      ),
    );

    final sidebar = Sidebar(
      top: Text(
        'Overview',
        style: textTheme.titleLarge!.copyWith(color: Colors.white),
      ),
      bottom: const VersionLabel(),
      isResizable: false,
      dragClosed: false,
      minWidth: 300,
      builder: (context, scrollController) => SidebarItems(
        items: panes.toSidebarItems(),
        currentIndex: PageIndexController.index,
        onChanged: (newIndex) {
          if (newIndex < activeScreens.length) {
            PageIndexController.index = newIndex;
          }
        },
      ),
    );

    final pane = NavigationPane(
      selected: PageIndexController.index,
      onChanged: (newIndex) {
        if (newIndex < activeScreens.length) {
          PageIndexController.index = newIndex;
        }
      },
      displayMode: PaneDisplayMode.auto,
      header: const Text('Bonfire Crash Course'),
      items: panes.toNavigationPaneItems(),
      footerItems: [
        PaneItemSeparator(),
        PaneItem(
          icon: const WindowsIcon(WindowsIcons.settings),
          title: const Text('Settings'),
          body: const SizedBox.shrink(),
          onTap: () => debugPrint('Settings clicked'),
        ),
      ],
    );

    if (PlatformResolver.isWindows) {
      // Windows / Fluent UI navigation pane
      return NavigationView(
        pane: pane,
        paneBodyBuilder: (item, body) => Padding(
          padding: const EdgeInsets.all(32.0),
          child: IndexedStack(
            index: PageIndexController.index,
            children: activeScreens,
          ),
        ),
      );
    } else {
      // macOS sidebar
      return MacosWindow(
        endSidebar: endSidebar,
        sidebar: sidebar,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: IndexedStack(
            index: PageIndexController.index,
            children: activeScreens,
          ),
        ),
      );
    }
  }
}
