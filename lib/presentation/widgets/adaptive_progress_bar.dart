import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart' as mac;

class AdaptiveProgressBar extends StatelessWidget {
  final double progress;

  const AdaptiveProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return PlatformResolver.isMacOS
        ? _buildMacOsProgressBar()
        : _buildWindowsProgressBar();
  }

  Widget _buildWindowsProgressBar() => fluent.ProgressBar(value: progress);
  Widget _buildMacOsProgressBar() => mac.ProgressBar(value: progress);
}
