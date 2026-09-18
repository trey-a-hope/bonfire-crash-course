import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart' as mac;

/// A platform-adaptive list tile that displays a key lesson [Concept].
///
/// Automatically switches between a macOS-styled [mac.MacosListTile] and
/// a Windows Fluent UI [fluent.ListTile.selectable], rendering the concept's
/// title, descriptive subtitle, and an accent lightbulb icon.
class AdaptiveListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  /// Creates a new [AdaptiveListTile] for the given [concept].
  const AdaptiveListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformResolver.isMacOS
        ? _buildMacOsListTile(context)
        : _buildWindowsListTile(context);
  }

  /// Builds the Windows Fluent UI representation of the concept tile.
  Widget _buildWindowsListTile(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return fluent.ListTile.selectable(
      leading: Icon(icon, color: fluent.Colors.yellow),
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(color: Colors.white),
      ),
      subtitle: Text(subtitle, style: textTheme.bodyMedium),
      onPressed: () {
        debugPrint('onTap');
      },
    );
  }

  /// Builds the macOS-styled representation of the concept tile.
  Widget _buildMacOsListTile(BuildContext context) {
    return mac.MacosListTile(
      leading: Icon(icon, color: fluent.Colors.yellow),
      title: Text(title, style: mac.MacosTheme.of(context).typography.headline),
      subtitle: Text(
        subtitle,
        style: mac.MacosTheme.of(context).typography.subheadline.copyWith(
          color: mac.MacosColors.systemGrayColor,
        ),
      ),
      onClick: () {
        debugPrint('onClick');
      },
    );
  }
}
