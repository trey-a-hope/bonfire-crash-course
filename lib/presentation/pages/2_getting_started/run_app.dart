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
            'Click Open in Browser',
          ],
        ),
        GapSizes.mediumGap,
        CommandBox(command: runCommand),
        GapSizes.largeGap,
        OneLineTip(
          text: 'Save a file and the game updates in a second (hot reload).',
        ),
      ],
    );
  }
}
