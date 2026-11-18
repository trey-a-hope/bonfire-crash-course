import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:material_ui/material_ui.dart';

import 'getting_started_module.dart';

class CreateAccountOnGithub extends StatelessWidget {
  const CreateAccountOnGithub({super.key});

  static const String githubSignupUrl = 'https://github.com/signup';
  static const String bannerAsset =
      'assets/images/screenshots/create_github_account.png';

  @override
  Widget build(BuildContext context) {
    return InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      unitStep: 1,
      title: 'Create an Account on GitHub',
      subtitle: 'Your free key to the course template and cloud editor.',
      leftPaneWidgets: [
        HeroImage(
          imagePath: bannerAsset,
          width: double.infinity,
          fit: BoxFit.fitWidth,
          borderRadius: BorderRadius.circular(16),
        ),
      ],
      rightPaneWidets: const [
        AnimatedHeroCard(scene: GettingStartedScene.githubAccount),
        GapSizes.largeGap,

        QuickSteps(
          steps: [
            'Open GitHub sign up',
            'Sign in with Google, Apple, or email/password',
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
