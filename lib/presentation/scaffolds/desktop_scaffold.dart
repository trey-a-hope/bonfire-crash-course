import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_navigator.dart';
import 'package:bonfire_crash_course/presentation/widgets/sidebar_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';

/// The primary desktop window shell for the application.
///
/// Implements a responsive split-view desktop layout:
/// - A left sidebar with branding, navigation tree, and settings.
/// - A main content window hosting the active lesson branch and navigation controls.
///
/// Built with pure Flutter Material widgets to provide a consistent desktop
/// experience across all host operating systems.
class DesktopScaffold extends SignalStatefulWidget {
  final StatefulNavigationShell navigationShell;

  /// Creates the [AdaptiveWindow] shell widget.
  const DesktopScaffold({super.key, required this.navigationShell});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

/// State implementation managing desktop navigation and layout.
class _DesktopScaffoldState extends State<DesktopScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _lastIndex = -1;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    final curved = CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOut,
    );
    _fadeAnimation = curved;
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.025),
      end: Offset.zero,
    ).animate(curved);
    _transitionController.forward();
    _lastIndex = widget.navigationShell.currentIndex;
  }

  @override
  void didUpdateWidget(DesktopScaffold old) {
    super.didUpdateWidget(old);
    if (widget.navigationShell.currentIndex != _lastIndex) {
      _lastIndex = widget.navigationShell.currentIndex;
      _transitionController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final progressPercentage = ProgressNavigationController.progress(
      widget.navigationShell,
    );
    final progressFraction = (progressPercentage / 100.0).clamp(0.0, 1.0);
    final isComplete = progressPercentage.toInt() >= 100;
    final progressColor = isComplete
        ? const Color(0xFFFFD700)
        : Colors.blueAccent;

    // Left Sidebar
    final sidebar = SizedBox(
      width: 280,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFF141416)),
        child: Column(
          children: [
            // Top Header: Branding & Progress
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          color: Colors.orangeAccent,
                          size: 20.0,
                        ),
                      ),
                      GapSizes.smallGap,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonfire Crash Course',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                            Text(
                              'Interactive Guide',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white38,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFF26262B)),

            // Middle: Navigation Items List
            Expanded(
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: panes.length,
                  itemBuilder: (context, index) {
                    final pane = panes[index];
                    if (pane.isParent) {
                      final isAnyChildActive = pane.children.any(
                        (c) =>
                            ProgressNavigationController.navigateablePanes
                                .indexOf(c) ==
                            widget.navigationShell.currentIndex,
                      );

                      return ExpansionTile(
                        key: PageStorageKey(pane.title),
                        initiallyExpanded:
                            pane.initiallyExpanded || isAnyChildActive,
                        shape: const Border(),
                        collapsedShape: const Border(),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 2.0,
                        ),
                        childrenPadding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 4.0,
                        ),
                        leading: pane.icon != null
                            ? IconTheme(
                                data: IconThemeData(
                                  size: 18.0,
                                  color: isAnyChildActive
                                      ? Colors.blueAccent
                                      : Colors.white70,
                                ),
                                child: pane.icon!,
                              )
                            : null,
                        title: Text(
                          pane.title,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: isAnyChildActive
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        iconColor: Colors.white70,
                        collapsedIconColor: Colors.white38,
                        children: [
                          for (final child in pane.children) ...[
                            _buildChildItem(child, isChild: true),
                          ],
                        ],
                      );
                    }

                    return _buildChildItem(pane);
                  },
                ),
              ),
            ),

            // Bottom Footer: Settings
            const Divider(height: 1, thickness: 1, color: Color(0xFF26262B)),
            Padding(
              padding: const EdgeInsetsGeometry.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${progressPercentage.toInt()}%',
                        style: textTheme.bodySmall?.copyWith(
                          color: progressColor,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GapSizes.xsGap,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: LinearProgressIndicator(
                      value: progressFraction,
                      minHeight: 5.0,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Right Content Window
    final content = Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: widget.navigationShell,
              ),
            ),
          ),
        ),
        // Hide prev/next nav on introduction page
        if (widget.navigationShell.currentIndex > 0) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 32.0),
            child: PageNavigator(navigationShell: widget.navigationShell),
          ),
        ],
      ],
    );

    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1B1B1E),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          surface: Color(0xFF141416),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF1B1B1E),
        body: Row(
          children: [
            sidebar,
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: Color(0xFF26262B),
            ),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }

  Widget _buildChildItem(PaneInfo pane, {bool isChild = false}) {
    final branchIndex = ProgressNavigationController.navigateablePanes.indexOf(
      pane,
    );
    final isSelected = branchIndex == widget.navigationShell.currentIndex;

    return SidebarItemTile(
      icon: isChild ? null : pane.icon,
      title: pane.title,
      isSelected: isSelected,
      onTap: () {
        if (branchIndex != -1) {
          _onChanged(branchIndex);
        }
      },
    );
  }

  /// Handles navigation pane selection changes.
  void _onChanged(int val) => widget.navigationShell.goBranch(
    val,
    initialLocation: val == widget.navigationShell.currentIndex,
  );
}
