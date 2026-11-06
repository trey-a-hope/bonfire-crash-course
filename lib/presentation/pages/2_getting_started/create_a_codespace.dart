import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

import 'getting_started_module.dart';

class CreateACodespace extends StatelessWidget {
  const CreateACodespace({super.key});

  @override
  Widget build(BuildContext context) {
    return const InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      unitStep: 2,
      title: 'Create a Codespace',
      subtitle:
          'VS Code and Flutter, ready in your browser. Nothing to install.',
      leftPaneWidgets: [AnimatedHeroCard(scene: GettingStartedScene.codespace)],
      rightPaneWidets: [
        QuickSteps(
          steps: [
            'Click Create a Codespace',
            'Press the green Create codespace',
            'Wait for your editor to open',
          ],
        ),
        GapSizes.largeGap,
        OpenLinkButton(
          title: 'Create a Codespace',
          url: CODE_SPACES_TEMPLATE_URL,
        ),
        GapSizes.largeGap,
        OneLineTip(
          text: 'The first launch takes about 90 seconds. After that, about 5.',
        ),
      ],
    );
  }
}
