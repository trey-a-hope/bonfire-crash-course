import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'getting_started_module.dart';

part 'vscode_install.dart';

/// Shows only the VS Code instructions for the computer the app runs on.
class InstallVSCode extends StatelessWidget {
  static const String bannerAsset =
      'assets/images/screenshots/download_visual_studio_code.png';

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
        HeroImage(
          imagePath: bannerAsset,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ],
      rightPaneWidets: [
        const AnimatedHeroCard(scene: GettingStartedScene.vscode),
        GapSizes.largeGap,
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
          text:
              'Choose a Codespace if you want to start right away with nothing to install, on any computer, as long as you have steady internet and stay within the free monthly hours. Choose VS Code on your own computer if you want to work offline with no time limits, get faster reloads, and keep a setup you can use for your own games after the course. If you’re not sure, start in a Codespace and switch to VS Code once you want to build your own game.',
        ),
      ],
    );
  }
}
