import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';

/// An individual navigation tile rendered within the desktop sidebar.
///
/// Displays an optional leading [icon] alongside a [title] label. Visually indicates
/// the active state when [isSelected] is `true` with an accent-tinted background,
/// highlighted text, and emphasized icon coloring. Supports desktop hover effects
/// and invokes [onTap] when selected.
class SidebarItemTile extends StatelessWidget {
  /// An optional leading icon displayed before the [title].
  final Widget? icon;

  /// The text label describing the destination or lesson module.
  final String title;

  /// Whether this item corresponds to the currently active navigation branch.
  final bool isSelected;

  /// Callback dispatched when the user clicks or taps this tile.
  final VoidCallback onTap;

  /// Creates a [SidebarItemTile].
  const SidebarItemTile({
    super.key,
    this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Material(
        // Highlight active selection with a translucent accent tint
        color: isSelected
            ? Colors.blue.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          hoverColor: Colors.white.withValues(alpha: 0.05),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                // Optional leading icon themed based on selection state
                if (icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      size: 16.0,
                      color: isSelected ? Colors.blueAccent : Colors.white54,
                    ),
                    child: icon!,
                  ),
                  GapSizes.mediumGap,
                ],
                // Navigation item title label
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
