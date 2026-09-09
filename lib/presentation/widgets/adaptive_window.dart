import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/core/panes.dart';
import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:bonfire_crash_course/presentation/widgets/version_label.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;

import 'package:bonfire_crash_course/core/platform_resolver.dart';
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
  late final Signal<int> _index = signal(0);

  // Recursively extract only items that have content/screens
  List<Widget> _extractScreens(List<PaneInfo> items) {
    final List<Widget> screens = [];
    for (final item in items) {
      if (item.child != null) {
        screens.add(item.child!);
      }
      if (item.children.isNotEmpty) {
        screens.addAll(_extractScreens(item.children));
      }
    }
    return screens;
  }

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
    final activeScreens = _extractScreens(panes);
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
        sidebar: Sidebar(
          minWidth: 300,
          builder: (context, scrollController) {
            return Column(
              children: [
                Expanded(
                  child: SidebarItems(
                    items: _buildSidebarItems(panes),
                    currentIndex: _index.value,
                    onChanged: (newIndex) {
                      if (newIndex < activeScreens.length) {
                        _index.value = newIndex;
                      }
                    },
                  ),
                ),
                const VersionLabel(),
                GapSizes.smallGap,
              ],
            );
          },
        ),
        child: IndexedStack(index: _index.value, children: activeScreens),
      );
    }
  }
}
