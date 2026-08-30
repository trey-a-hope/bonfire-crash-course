import 'package:bonfire_crash_course/main.dart';
import 'package:flutter/material.dart';

class VersionLabel extends StatelessWidget {
  const VersionLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(
      'Bonfire Crash Course v${packageInfo.version} (build ${packageInfo.buildNumber})',
      textAlign: TextAlign.center,
      style: textTheme.bodyMedium?.copyWith(color: Colors.white),
    );
  }
}
