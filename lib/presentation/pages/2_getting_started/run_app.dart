import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

import 'getting_started_module.dart';

class RunApp extends StatelessWidget {
  const RunApp({super.key});

  /// Starts the template game as a web server the Codespace can open.
  static const runCommand = 'flutter run -d web-server --web-port 8080';

  @override
  Widget build(BuildContext context) {
    return const InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      unitStep: 5,
      title: 'Run the App',
      subtitle: 'One command, and your game is live.',
      leftPaneWidgets: [AnimatedHeroCard(scene: GettingStartedScene.runGame)],
      rightPaneWidets: [
        QuickSteps(
          steps: [
            'Open the terminal (Ctrl or Cmd + `)',
            'Run the command below',
            'Open port 8080 in your browser',
          ],
        ),
        GapSizes.mediumGap,
        CommandBox(command: runCommand),
        GapSizes.largeGap,
        OneLineTip(
          text: 'Changed some code? Press r in the terminal to hot reload.',
        ),
      ],
    );
  }
}
