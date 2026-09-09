import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;

import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:signals/signals_flutter.dart';

final Map<PaneInfo, List<PaneInfo>> panessss = {
  PaneInfo(icon: Icon(Icons.abc), title: 'Gettings Started', child: null): [],
  PaneInfo(icon: Icon(Icons.abc), title: 'Players', child: null): [
    PaneInfo(
      icon: Icon(Icons.abc),
      title: 'Simple PLayer',
      child: Placeholder(color: Colors.green),
    ),
    PaneInfo(
      icon: Icon(Icons.abc),
      title: 'Simple PLayer',
      child: Placeholder(color: Colors.red),
    ),
  ],
  PaneInfo(icon: Icon(Icons.abc), title: 'Environment', child: null): [],
};

class AdaptiveWindow extends SignalStatefulWidget {
  final List<PaneInfo> panes;

  const AdaptiveWindow({super.key, required this.panes});

  @override
  State<AdaptiveWindow> createState() => _AdaptiveWindowState();
}

/// A platform‑adaptive sidebar that shows a Fluent UI NavigationPane on
/// Windows and a macOS UI Sidebar on macOS.
class _AdaptiveWindowState extends State<AdaptiveWindow> {
  late final Signal<int> _index = signal(0);

  @override
  Widget build(BuildContext context) {
    if (PlatformResolver.isWindows) {
      // Windows / Fluent UI navigation pane
      final children = widget.panes.map((p) => p.child).toList();
      return NavigationView(
        pane: NavigationPane(
          selected: _index.value,
          onChanged: (index) => _index.value = index,
          displayMode: PaneDisplayMode.auto,
          header: const Text('Pane Header'),
          items: widget.panes
              .map(
                (pane) => PaneItem(
                  icon: pane.icon,
                  title: Text(pane.title),
                  // body is omitted; content will be rendered via IndexedStack below
                  body: const SizedBox.shrink(),
                ),
              )
              .toList(),
        ),
        // Preserve state of each pane child using IndexedStack
        content: IndexedStack(
          index: _index.value,
          children: children.where((p) => p != null).map((p) => p!).toList(),
        ),
      );
    } else {
      // macOS sidebar
      final children = widget.panes.map((p) => p.child).toList();
      return MacosWindow(
        sidebar: Sidebar(
          builder: (c, s) {
            return SidebarItems(
              items: widget.panes
                  .map(
                    (e) => SidebarItem(
                      leading: e.icon,
                      label: Text(e.title),
                      disclosureItems: [
                        SidebarItem(
                          leading: e.icon,
                          label: Text(e.title),
                          disclosureItems: [],
                        ),
                      ],
                    ),
                  )
                  .toList(),
              currentIndex: _index.value,
              onChanged: (index) => _index.value = index,
            );
          },
          minWidth: 300,
        ),
        // Preserve state of each pane child using IndexedStack
        child: IndexedStack(
          index: _index.value,
          children: children.where((p) => p != null).map((p) => p!).toList(),
        ),
      );
    }
  }
}
