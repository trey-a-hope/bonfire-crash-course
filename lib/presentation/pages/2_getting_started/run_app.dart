import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

import 'getting_started_module.dart';

class RunApp extends StatelessWidget {
  static const String SCREENSHOT =
      'assets/images/screenshots/start_codespace.png';

  const RunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      unitStep: 4,
      title: 'Run the App',
      subtitle: 'One command, and your game is live.',
      // leftPaneWidgets: [AnimatedHeroCard(scene: GettingStartedScene.runGame)],
      leftPaneWidgets: [
        HeroImage(
          imagePath: SCREENSHOT,
          width: double.infinity,
          fit: BoxFit.fitWidth,
          borderRadius: BorderRadius.circular(16),
        ),
      ],
      rightPaneWidets: const [
        QuickSteps(
          steps: [
            'Once the codespace is open, locate the green arrow (next to "Codespaces")',
            'Press the button to start the app',
            'Once the app loads in the preview window to the right, you can start playing the game',
          ],
        ),
        GapSizes.mediumGap,
        GapSizes.largeGap,
        OneLineTip(
          text: 'Changed some code? Press r in the terminal to hot reload.',
        ),
        GapSizes.mediumGap,
        OneLineTip(
          text:
              'Curious what\'s inside? Open Starter Project Files in the sidebar anytime.',
        ),
      ],
    );
  }
}
