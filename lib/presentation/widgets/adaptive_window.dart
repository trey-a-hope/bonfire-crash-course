import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:signals/signals_flutter.dart';

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
                  body: pane.child,
                ),
              )
              .toList(),
        ),
      );
    } else {
      // macOS sidebar
      return MacosWindow(
        sidebar: Sidebar(
          builder: (c, s) {
            return SidebarItems(
              items: widget.panes
                  .map(
                    (e) => SidebarItem(leading: e.icon, label: Text(e.title)),
                  )
                  .toList(),
              currentIndex: _index.value,
              onChanged: (index) => _index.value = index,
            );
          },
          minWidth: 300,
        ),
        child: widget.panes[_index.value].child,
      );
    }
  }
}
