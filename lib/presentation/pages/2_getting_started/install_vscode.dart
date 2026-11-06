import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'getting_started_module.dart';

part 'vscode_install.dart';

/// Shows only the VS Code instructions for the computer the app runs on.
class InstallVSCode extends StatelessWidget {
  const InstallVSCode({super.key});

  @override
  Widget build(BuildContext context) {
    final install = VSCodeInstall.forPlatform(defaultTargetPlatform);

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
        QuickSteps(steps: install.steps),
        GapSizes.largeGap,
        OpenLinkButton(
          title: install.buttonTitle,
          url: install.url,
          icon: install.icon,
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
