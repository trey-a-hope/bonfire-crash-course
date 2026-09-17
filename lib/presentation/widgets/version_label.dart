import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/main.dart';
import 'package:flutter/material.dart';

class VersionLabel extends StatelessWidget {
  const VersionLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          'Bonfire Crash Course v${packageInfo.version}+${packageInfo.buildNumber} ',
          style: textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        Text(
          'for ${PlatformResolver.isMacOS ? 'macOS' : 'Windows'}',
          style: textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
