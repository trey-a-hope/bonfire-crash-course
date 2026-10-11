import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'getting_started_module.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/benefit_row.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/app_card.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:bonfire_crash_course/presentation/widgets/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateAccountOnGithub extends StatelessWidget {
  const CreateAccountOnGithub({super.key});

  static const String _githubSignupUrl = 'https://github.com/signup';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      leftPaneWidgets: [
        Text(
          'Why Do You Need a GitHub Account?',
          style: textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        GapSizes.xsGap,
        Text(
          'GitHub is the world’s leading platform for hosting and collaborating on code. For this course, GitHub provides two essential capabilities: hosting our Bonfire starter template and powering GitHub Codespaces—giving you a complete, cloud-hosted VS Code and Flutter environment right in your browser.',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
            height: 1.5,
          ),
        ),
        GapSizes.largeGap,
        Text(
          'Step-by-Step Sign Up',
          style: textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        GapSizes.smallGap,
        const StepsWidget.simple(
          steps: [
            'Select the "Go to GitHub Sign Up" button below to open github.com/signup.',
            'Enter your primary email address and click "Continue".',
            'Create a secure password and choose your unique developer username.',
            'Solve the verification puzzle and enter the launch code sent to your email.',
            'Once signed in, return here and advance to the next step to create your Codespace!',
          ],
        ),
        GapSizes.largeGap,
        Center(
          child: GlassButton(
            title: 'Go to GitHub Sign Up',
            prefixIconData: Icons.open_in_new_rounded,
            onPressed: () async {
              final uri = Uri.parse(_githubSignupUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            color: Colors.purpleAccent,
          ),
        ),
      ],
      rightPaneWidets: [
        // Free Developer Tier Benefits Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.verified_user_rounded,
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                  GapSizes.smallGap,
                  Text(
                    'Free Developer Tier',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GapSizes.smallGap,
              Text(
                'Every free personal account on GitHub includes generous benefits so you can complete this entire course without paying anything:',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.45,
                ),
              ),
              GapSizes.mediumGap,
              const BenefitRow(
                icon: Icons.access_time_filled_rounded,
                accentColor: Colors.blueAccent,
                title: '60 Free Codespace Hours',
                subtitle:
                    'Per month on a 2-core cloud machine—far more than needed for this course.',
              ),
              GapSizes.smallGap,
              const BenefitRow(
                icon: Icons.cloud_sync_rounded,
                accentColor: Colors.greenAccent,
                title: 'Automatic Cloud Backup',
                subtitle:
                    'Every line of code and custom map asset is safely backed up to your repo.',
              ),
              GapSizes.smallGap,
              const BenefitRow(
                icon: Icons.devices_rounded,
                accentColor: Colors.purpleAccent,
                title: 'Code From Any Device',
                subtitle:
                    'Resume game development from any browser on Mac, Windows, Linux, or tablet.',
              ),
            ],
          ),
        ),
        GapSizes.mediumGap,
        // "Already Have an Account?" Info Card
        AppCard.info(
          title: 'Already Have an Account?',
          description:
              'If you already have a GitHub account, you are all set! You can proceed directly to the next lesson: "Create a Codespace".',
        ),
      ],
      unitStep: 1,
      title: "Create an Account on GitHub",
      subtitle:
          "Set up your free GitHub account to access course templates and launch your cloud development environment.",
    );
  }
}
