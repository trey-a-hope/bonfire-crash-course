import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

import 'getting_started_module.dart';

class CreateAccountOnGithub extends StatelessWidget {
  const CreateAccountOnGithub({super.key});

  static const String githubSignupUrl = 'https://github.com/signup';

  @override
  Widget build(BuildContext context) {
    return const InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      unitStep: 1,
      title: 'Create an Account on GitHub',
      subtitle: 'Your free key to the course template and cloud editor.',
      leftPaneWidgets: [
        AnimatedHeroCard(scene: GettingStartedScene.githubAccount),
      ],
      rightPaneWidets: [
        QuickSteps(
          steps: [
            'Open GitHub sign up',
            'Pick a username and password',
            'Verify your email',
          ],
        ),
        GapSizes.largeGap,
        OpenLinkButton(title: 'Go to GitHub Sign Up', url: githubSignupUrl),
        GapSizes.largeGap,
        OneLineTip(text: 'Already have an account? Skip to the next step.'),
      ],
    );
  }
}
