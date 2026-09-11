import 'package:bonfire_crash_course/domain/controllers/page_index_controller.dart';
import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:bonfire_crash_course/presentation/widgets/version_label.dart';

import 'package:bonfire_crash_course/core/platform_resolver.dart';
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
  List<SidebarItem> _buildSidebarItems(List<PaneInfo> items) => items
      .map(
        (e) => SidebarItem(
          leading: e.icon,
          label: Text(e.title),
          disclosureItems: e.children.isNotEmpty
              ? _buildSidebarItems(e.children)
              : null,
        ),
      )
      .toList();

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
              clearButtonMode: OverlayVisibilityMode.always,
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
        items: _buildSidebarItems(panes),
        currentIndex: PageIndexController.index,
        onChanged: (newIndex) {
          if (newIndex < activeScreens.length) {
            PageIndexController.index = newIndex;
          }
        },
      ),
    );

    if (PlatformResolver.isWindows) {
      // // Windows / Fluent UI navigation pane
      // final children = widget.panes.map((p) => p.child).toList();
      // return NavigationView(
      //   pane: NavigationPane(
      //     selected: _index.value,
      //     onChanged: (index) => _index.value = index,
      //     displayMode: PaneDisplayMode.auto,
      //     header: const Text('Pane Header'),
      //     items: widget.panes
      //         .map(
      //           (pane) => PaneItem(
      //             icon: pane.icon,
      //             title: Text(pane.title),
      //             // body is omitted; content will be rendered via IndexedStack below
      //             body: const SizedBox.shrink(),
      //           ),
      //         )
      //         .toList(),
      //   ),
      //   // Preserve state of each pane child using IndexedStack
      //   content: IndexedStack(
      //     index: _index.value,
      //     children: children.where((p) => p != null).map((p) => p!).toList(),
      //   ),
      // );
      return Placeholder();
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
