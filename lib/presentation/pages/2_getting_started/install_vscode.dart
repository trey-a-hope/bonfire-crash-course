import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:bonfire_crash_course/presentation/widgets/platform_chip.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import 'getting_started_module.dart';

class InstallVSCode extends SignalStatefulWidget {
  const InstallVSCode({super.key});

  static const macSteps = [
    'Download VS Code for macOS',
    'Drag it into Applications',
    'Add the Flutter and Dart extensions',
  ];

  static const windowsSteps = [
    'Download and run the installer',
    'Tick Add to PATH',
    'Add the Flutter and Dart extensions',
  ];

  @override
  State<InstallVSCode> createState() => _InstallVSCodeState();
}

class _InstallVSCodeState extends State<InstallVSCode> {
  /// Whether the macOS steps are showing (otherwise Windows).
  late final _showMacOs = Signal<bool>(PlatformResolver.isMacOS);

  @override
  void dispose() {
    _showMacOs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showMacOs = _showMacOs.value;

    return InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      unitStep: 3,
      unitExtra: 'Optional Setup',
      title: 'Install VS Code',
      subtitle: 'Prefer coding offline? Put VS Code on your own computer.',
      leftPaneWidgets: const [
        AnimatedHeroCard(scene: GettingStartedScene.vscode),
      ],
      rightPaneWidets: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlatformChip(
                  title: 'macOS',
                  isSelected: showMacOs,
                  onTap: () => _showMacOs.value = true,
                ),
                PlatformChip(
                  title: 'Windows',
                  isSelected: !showMacOs,
                  onTap: () => _showMacOs.value = false,
                ),
              ],
            ),
          ),
        ),
        GapSizes.mediumGap,
        // Keyed by platform, so the steps slide in again on a switch.
        QuickSteps(
          key: ValueKey(showMacOs),
          steps: showMacOs
              ? InstallVSCode.macSteps
              : InstallVSCode.windowsSteps,
        ),
        GapSizes.largeGap,
        OpenLinkButton(
          title: showMacOs ? 'Download for macOS' : 'Download for Windows',
          url: showMacOs ? VSCODE_DOWNLOAD_MACOS : VSCODE_DOWNLOAD_WINDOWS,
          icon: showMacOs ? Icons.apple : Icons.desktop_windows_rounded,
          color: Colors.tealAccent,
        ),
        GapSizes.largeGap,
        const OneLineTip(
          text: 'Optional: your Codespace already runs VS Code.',
        ),
      ],
    );
  }
}
