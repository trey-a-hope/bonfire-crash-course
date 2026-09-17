import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/version_label.dart';
import 'package:flutter/material.dart';

class SettingsSheetView extends StatelessWidget {
  const SettingsSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsetsGeometry.all(64),
      child: Column(
        children: [
          Text(
            'Settings',
            style: textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          GapSizes.xlGap,
          const Expanded(child: Placeholder()),
          GapSizes.xlGap,
          const Center(child: VersionLabel()),
          GapSizes.xlGap,
          AdaptiveButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
