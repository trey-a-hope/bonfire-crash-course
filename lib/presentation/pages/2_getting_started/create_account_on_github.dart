import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateAccountOnGithub extends StatelessWidget {
  const CreateAccountOnGithub({super.key});

  static const String _githubSignupUrl = 'https://github.com/signup';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create an Account on GitHub',
          style: textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        GapSizes.xsGap,
        Text(
          'Set up your free GitHub account to access course templates and launch your cloud development environment.',
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
        GapSizes.largeGap,
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Overview, Steps & Sign-Up Action
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        child: AdaptiveButton(
                          type: AdaptiveButtonType.filled,
                          onPressed: () async {
                            final uri = Uri.parse(_githubSignupUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.open_in_new_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              GapSizes.smallGap,
                              Text(
                                'Go to GitHub Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GapSizes.largeGap,
                    ],
                  ),
                ),
              ),
              GapSizes.largeGap,
              // Right Column: Benefits & Account Callout
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Free Developer Tier Benefits Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.blueAccent.withValues(alpha: 0.3),
                          ),
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
                                const SizedBox(width: 8),
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
                            _buildBenefitRow(
                              context,
                              icon: Icons.access_time_filled_rounded,
                              accentColor: Colors.blueAccent,
                              title: '60 Free Codespace Hours',
                              subtitle:
                                  'Per month on a 2-core cloud machine—far more than needed for this course.',
                            ),
                            GapSizes.smallGap,
                            _buildBenefitRow(
                              context,
                              icon: Icons.cloud_sync_rounded,
                              accentColor: Colors.greenAccent,
                              title: 'Automatic Cloud Backup',
                              subtitle:
                                  'Every line of code and custom map asset is safely backed up to your repo.',
                            ),
                            GapSizes.smallGap,
                            _buildBenefitRow(
                              context,
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
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: Colors.cyanAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Already Have an Account?',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'If you already have a GitHub account, you are all set! You can proceed directly to the next lesson: "Create a Codespace".',
                                    style: textTheme.bodySmall?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.75),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitRow(
    BuildContext context, {
    required IconData icon,
    required Color accentColor,
    required String title,
    required String subtitle,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
