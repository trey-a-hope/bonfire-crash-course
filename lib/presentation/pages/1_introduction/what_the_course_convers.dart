import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/_cards.dart';
import 'package:bonfire_crash_course/presentation/widgets/game_window.dart';
import 'package:flutter/material.dart';

class WhatTheCourseConvers extends StatelessWidget {
  /// Builds the game window's web view. Tests pass a fake; the app leaves it
  /// null to use the real one.
  final GameWebViewBuilder? gameWebViewBuilder;

  const WhatTheCourseConvers({super.key, this.gameWebViewBuilder});

  /// The most of the screen's height the game window may take, so the whole
  /// game stays in view on short screens.
  static const maxGameHeightFraction = 0.7;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What the Course Covers',
          style: textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        GapSizes.xsGap,
        Text(
          'A comprehensive, step-by-step masterclass on building 2D action RPGs using Flutter and the Bonfire game engine.',
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
        GapSizes.largeGap,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // BCC-36: play the finished template game first, as large as
                // the window allows while still leaving room to see it whole.
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.sizeOf(context).height *
                          maxGameHeightFraction *
                          16 /
                          9,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          child: Text(
                            'What you will be building today',
                            textAlign: TextAlign.center,
                            style: textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GameWindow(webViewBuilder: gameWebViewBuilder),
                      ],
                    ),
                  ),
                ),
                GapSizes.largeGap,
                // The five course modules, split into two even columns.
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ModuleCard(
                            stepNumber: '01',
                            icon: Icons.cloud_done_rounded,
                            accentColor: Colors.blueAccent,
                            title: 'Map',
                            description: '?',
                          ),
                          GapSizes.mediumGap,
                          ModuleCard(
                            stepNumber: '02',
                            icon: Icons.map_rounded,
                            accentColor: Colors.greenAccent,
                            title: 'Hero',
                            description: '?',
                          ),
                          GapSizes.mediumGap,
                          ModuleCard(
                            stepNumber: '03',
                            icon: Icons.sports_esports_rounded,
                            accentColor: Colors.orangeAccent,
                            title: 'Ally',
                            description: '?',
                          ),
                        ],
                      ),
                    ),
                    GapSizes.largeGap,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ModuleCard(
                            stepNumber: '04',
                            icon: Icons.sports_esports_rounded,
                            accentColor: Colors.orangeAccent,
                            title: 'Enemy',
                            description: '?',
                          ),
                          GapSizes.mediumGap,
                          ModuleCard(
                            stepNumber: '05',
                            icon: Icons.shield_rounded,
                            accentColor: Colors.purpleAccent,
                            title: 'Collisions, Combat & Mechanics',
                            description: '?',
                          ),
                          GapSizes.mediumGap,
                          ModuleCard(
                            stepNumber: '06',
                            icon: Icons.rocket_launch_rounded,
                            accentColor: Colors.tealAccent,
                            title: 'Decorations & Props',
                            description: '?',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
