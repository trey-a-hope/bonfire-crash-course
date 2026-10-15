import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';

/// A single settings row with a tinted leading icon, a title, an optional
/// subtitle, and an optional trailing control.
///
/// The leading icon badge follows the same tinted-circle treatment used by
/// [AppCard]. When [onTap] is provided the row shows desktop hover and press
/// feedback.
class SettingsTile extends StatelessWidget {
  /// The icon displayed in the leading badge.
  final IconData icon;

  /// The accent color used for the leading badge.
  final Color color;

  /// The primary label for this setting.
  final String title;

  /// Optional supporting text shown beneath [title].
  final String? subtitle;

  /// Optional control shown at the end of the row (switch, value, chevron).
  final Widget? trailing;

  /// Optional content shown beneath the title row, such as a slider.
  final Widget? bottom;

  /// Callback dispatched when the row is clicked or tapped.
  final VoidCallback? onTap;

  /// Whether [title] is drawn in [color] instead of white.
  final bool isDestructive;

  /// Creates a [SettingsTile].
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.color = Colors.blueAccent,
    this.subtitle,
    this.trailing,
    this.bottom,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.white.withValues(alpha: 0.05),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 20.0),
                    ),
                    GapSizes.mediumGap,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: textTheme.titleSmall?.copyWith(
                              color: isDestructive ? color : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (subtitle != null) ...[
                            GapSizes.xsGap,
                            Text(
                              subtitle!,
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) ...[GapSizes.mediumGap, trailing!],
                  ],
                ),
                if (bottom != null) ...[GapSizes.smallGap, bottom!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
