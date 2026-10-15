import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';

/// A titled group of settings rendered as a rounded, bordered panel.
///
/// Matches the sidebar surface colors so settings read as part of the same
/// desktop shell. Dividers are inserted between each of the [children].
class SettingsSection extends StatelessWidget {
  /// The uppercase label shown above the panel.
  final String title;

  /// The settings rows displayed inside the panel.
  final List<Widget> children;

  /// Creates a [SettingsSection].
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            title.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: Colors.white54,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
        GapSizes.smallGap,
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF141416),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: const Color(0xFF26262B)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFF26262B),
                    ),
                  children[i],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
