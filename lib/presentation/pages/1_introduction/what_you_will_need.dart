import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/lotties/flutter_lottie.dart';
import 'package:bonfire_crash_course/presentation/widgets/benefit_item.dart';
import 'package:bonfire_crash_course/presentation/widgets/requirement_card.dart';
import 'package:flutter/material.dart';

class WhatYouWillNeed extends StatelessWidget {
  const WhatYouWillNeed({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What You Will Need',
          style: textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        GapSizes.xsGap,
        Text(
          'Everything required to follow along and build your game. No specialized hardware or expensive software is needed.',
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
        GapSizes.largeGap,
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Requirements List
                const Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RequirementCard(
                        icon: Icons.account_circle_rounded,
                        accentColor: Colors.blueAccent,
                        badge: 'REQUIRED',
                        title: 'A Free GitHub Account',
                        description:
                            'You will need a GitHub account to access the course repository, fork the game starter template, and launch your cloud development workspace.',
                      ),
                      GapSizes.mediumGap,
                      RequirementCard(
                        icon: Icons.language_rounded,
                        accentColor: Colors.cyanAccent,
                        badge: 'REQUIRED',
                        title: 'A Modern Web Browser',
                        description:
                            'Chrome, Microsoft Edge, Brave, Safari, or Firefox. GitHub Codespaces runs full Visual Studio Code directly inside your browser tab with zero local installation.',
                      ),
                      GapSizes.mediumGap,
                      RequirementCard(
                        icon: Icons.code_rounded,
                        accentColor: Colors.amberAccent,
                        badge: 'RECOMMENDED',
                        title: 'Basic Dart & Flutter Familiarity',
                        description:
                            'Comfort with foundational Dart syntax (functions, classes, async) and Flutter widgets is helpful. No previous game development experience is required.',
                      ),
                      GapSizes.mediumGap,
                      RequirementCard(
                        icon: Icons.wifi_rounded,
                        accentColor: Colors.greenAccent,
                        badge: 'REQUIRED',
                        title: 'Internet Connection',
                        description:
                            'A stable internet connection to run Codespaces in the cloud, download game sprite assets, and stream course video walkthroughs.',
                      ),
                      GapSizes.mediumGap,
                      RequirementCard(
                        icon: Icons.laptop_chromebook_rounded,
                        accentColor: Colors.purpleAccent,
                        badge: 'OPTIONAL',
                        title: 'Local Flutter Environment (Optional)',
                        description:
                            'If you prefer working offline on your local computer rather than the cloud, you can install the Flutter SDK (3.19+) and VS Code or Android Studio.',
                      ),
                    ],
                  ),
                ),
                GapSizes.largeGap,
                // Right Column: Cloud-First Advantages & Getting Ready
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Cloud Workflow Spotlight
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.cyanAccent.withValues(alpha: 0.3),
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
                                  Icons.cloud_queue_rounded,
                                  color: Colors.cyanAccent,
                                  size: 24,
                                ),
                                GapSizes.smallGap,
                                Text(
                                  'Zero Local Setup',
                                  style: textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            GapSizes.smallGap,
                            Text(
                              'Say goodbye to spending hours wrestling with compilers, emulators, and gigabytes of SDK downloads. Codespaces provides an instant, pre-configured development environment.',
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                height: 1.5,
                              ),
                            ),
                            GapSizes.mediumGap,
                            const Center(child: FlutterLottie(height: 150)),
                            GapSizes.mediumGap,
                            const BenefitItem(
                              text:
                                  'Flutter & Dart pre-installed and configured',
                            ),
                            const BenefitItem(
                              text:
                                  'All game sprite assets and dependencies ready',
                            ),
                            const BenefitItem(
                              text:
                                  'Runs seamlessly on Mac, Windows, Linux & Chromebooks',
                            ),
                            const BenefitItem(
                              text:
                                  'Automatic cloud saves synced to your GitHub repo',
                            ),
                          ],
                        ),
                      ),
                      GapSizes.mediumGap,
                      // Next Step Callout
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blueAccent.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.blueAccent,
                              size: 20,
                            ),
                            GapSizes.mediumGap,
                            Expanded(
                              child: Text(
                                'Next up: in the "Getting Started" section, we will walk you through creating your GitHub account and launching your codespace in just a few clicks!',
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  height: 1.4,
                                ),
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
    );
  }
}
