import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/domain/models/pane_info.dart';
import 'package:bonfire_crash_course/presentation/pages/miscellaneous/course_info/course_info_page.dart';
import 'package:bonfire_crash_course/presentation/pages/miscellaneous/settings_page.dart';
import 'package:bonfire_crash_course/presentation/widgets/sidebar_item_tile.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

/// The fixed-width navigation sidebar shown by the desktop scaffold.
///
/// It has three sections, from top to bottom:
/// * a branding header,
/// * a scrollable list of course panes built from [panes], where parent panes
///   become collapsible groups,
/// * a footer with links to Course Info and Settings, plus a bar showing
///   overall course progress.
class Sidebar extends StatelessWidget {
  /// The index of the active branch in
  /// [ProgressNavigationController.navigateablePanes]. Used to highlight the
  /// selected item and to expand the group that contains it.
  final int currentIndex;

  /// Course progress from 0 to 100, shown as a whole-number label.
  final double progressPercentage;

  /// The color of the progress label and the filled part of the progress bar.
  final Color progressColor;

  /// Course progress from 0.0 to 1.0, used as the progress bar's value.
  final double progressFraction;

  /// Whether to show the progress label and bar. False before the Getting
  /// Started module, where progress hasn't started yet.
  final bool showProgress;

  /// Switches the shell route to the branch at [index].
  ///
  /// [initialLocation] is true when the user taps the item that is already
  /// selected, which resets that branch to its root route.
  final Function(int index, {bool initialLocation}) goBranch;

  const Sidebar({
    required this.currentIndex,
    required this.progressPercentage,
    required this.progressColor,
    required this.progressFraction,
    required this.showProgress,
    required this.goBranch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 280,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFF141416)),
        child: Column(
          children: [
            // Top Header: Branding & Progress
            Padding(
              // On phones/tablets, push the header below the status bar and
              // any notch or camera cutout. Desktop keeps the original 20px.
              padding: EdgeInsets.fromLTRB(
                16.0,
                PlatformResolver.isMobile
                    ? MediaQuery.paddingOf(context).top + 20.0
                    : 20.0,
                16.0,
                16.0,
              ),
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
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: panes.length,
                  itemBuilder: (context, index) {
                    final pane = panes[index];

                    // Parent panes (modules) render as collapsible groups of
                    // their lessons; leaf panes render as a single tile below.
                    if (pane.isParent) {
                      // A group is highlighted, and forced open, when the
                      // current page is one of its children.
                      final isAnyChildActive = pane.children.any(
                        (c) =>
                            ProgressNavigationController.navigateablePanes
                                .indexOf(c) ==
                            currentIndex,
                      );

                      return ExpansionTile(
                        // PageStorageKey keeps each group's open/closed state
                        // when the list rebuilds or scrolls.
                        key: PageStorageKey(pane.title),
                        initiallyExpanded:
                            pane.initiallyExpanded || isAnyChildActive,
                        // Empty borders remove the default divider lines
                        // ExpansionTile draws when expanded.
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
                          style: textTheme.bodyMedium?.copyWith(
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

            // Bottom Footer: reference pages pushed over the course shell
            // (never "selected", since they aren't course branches), then
            // Progress.
            const Divider(height: 1, thickness: 1, color: Color(0xFF26262B)),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SidebarItemTile(
                icon: const Icon(Icons.info_outline_rounded),
                title: 'Course Info',
                isSelected: false,
                onTap: () => context.push(CourseInfoPage.path),
              ),
            ),
            SidebarItemTile(
              icon: const Icon(Icons.settings_rounded),
              title: 'Settings',
              isSelected: false,
              onTap: () => context.push(SettingsPage.path),
            ),
            // Course progress: label + percentage, then a rounded bar.
            // Hidden until the Getting Started module.
            if (showProgress) ...[
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
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${progressPercentage.toInt()}%',
                          style: textTheme.bodySmall?.copyWith(
                            color: progressColor,
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
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a tappable tile for a single navigable [pane].
  ///
  /// When [isChild] is true the tile sits inside a parent group, so its icon
  /// is hidden to keep nested items visually lighter.
  Widget _buildChildItem(PaneInfo pane, {bool isChild = false}) {
    // Where this pane sits among the router branches; -1 if it isn't routable.
    final branchIndex = ProgressNavigationController.navigateablePanes.indexOf(
      pane,
    );
    final isSelected = branchIndex == currentIndex;

    return SidebarItemTile(
      icon: isChild ? null : pane.icon,
      title: pane.title,
      isSelected: isSelected,
      onTap: () {
        // Ignore taps on panes with no branch. Tapping the active item again
        // resets its branch to the initial location.
        if (branchIndex != -1) {
          goBranch(branchIndex, initialLocation: branchIndex == currentIndex);
        }
      },
    );
  }
}
