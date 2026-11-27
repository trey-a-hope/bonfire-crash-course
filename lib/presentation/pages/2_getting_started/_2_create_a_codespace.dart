import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/modules/getting_started_module.dart';

class CreateACodespace extends StatelessWidget {
  static const String CODE_SPACES_TEMPLATE_URL =
      'https://github.com/codespaces/new?repo=1449918845&skip_quickstart=true&machine=basicLinux32gb&ref=main&devcontainer_path=.devcontainer%2Fdevcontainer.json&geo=UsWest';

  static const String SCREENSHOT =
      'assets/images/screenshots/create_codespace.png';

  const CreateACodespace({super.key});

  @override
  Widget build(BuildContext context) {
    return InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      unitStep: 2,
      title: 'Create a Codespace',
      subtitle:
          'VS Code and Flutter, ready in your browser. Nothing to install.',
      leftPaneWidgets: [
        HeroImage(
          imagePath: SCREENSHOT,
          width: double.infinity,
          fit: BoxFit.fitWidth,
          borderRadius: BorderRadius.circular(16),
        ),
      ],
      rightPaneWidets: const [
        AnimatedHeroCard(scene: GettingStartedScene.codespace),
        GapSizes.largeGap,

        QuickSteps(
          steps: [
            'Click "Create a Codespace" down below',
            'In the new window, click "Create codespace"',
          ],
        ),
        GapSizes.largeGap,
        OpenLinkButton(
          title: 'Create a Codespace',
          url: CODE_SPACES_TEMPLATE_URL,
        ),
        GapSizes.largeGap,
        OneLineTip(
          text: 'Codespace usage: free to use! Each GitHub account gets about 60 hours a month on this template\'s machine. If you use them all, your codespace pauses until next month and you\'re never charged. Stop your codespace when you\'re done to make the hours last.',
        ),
      ],
    );
  }
}
