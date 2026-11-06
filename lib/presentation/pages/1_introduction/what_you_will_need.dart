import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/rive/getting_started/getting_started_rive.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

part 'need_tile.dart';
part 'optional_chip.dart';
part 'zero_setup_card.dart';

/// What a student needs before starting, in one layout at every window
/// size: three must-haves side by side, a line of optional extras, a
/// one-line tip, then a "Zero setup" card with a Rive animation.
class WhatYouWillNeed extends StatelessWidget {
  const WhatYouWillNeed({super.key});

  /// The three things every student needs.
  static const needs = [
    NeedTile(
      icon: Icons.account_circle_rounded,
      color: Colors.blueAccent,
      title: 'A free GitHub account',
      line: 'Takes about a minute.',
    ),
    NeedTile(
      icon: Icons.language_rounded,
      color: Colors.cyanAccent,
      title: 'A web browser',
      line: 'Chrome, Edge, Safari or Firefox.',
      delay: Duration(milliseconds: 120),
    ),
    NeedTile(
      icon: Icons.wifi_rounded,
      color: Colors.greenAccent,
      title: 'An internet connection',
      line: 'Your code runs in the cloud.',
      delay: Duration(milliseconds: 240),
    ),
  ];

  /// Helpful, but not needed: shown on one line under the tiles.
  static const optionals = [
    OptionalChip(
      icon: Icons.code_rounded,
      color: Colors.amberAccent,
      label: 'Some Dart & Flutter basics',
    ),
    OptionalChip(
      icon: Icons.laptop_rounded,
      color: Colors.purpleAccent,
      label: 'VS Code on your own computer',
    ),
  ];

  /// What the cloud workspace already has ready.
  static const setupChecks = [
    'Flutter and Dart ready to go',
    'Game art already included',
    'Works on any computer',
  ];

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
          'Just three things, all free. No special hardware.',
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
                // Always three across; the tiles get narrower, not stacked.
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (i, tile) in needs.indexed) ...[
                        if (i > 0) GapSizes.mediumGap,
                        Expanded(child: tile),
                      ],
                    ],
                  ),
                ),
                GapSizes.largeGap,
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'OPTIONAL',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    ...optionals,
                  ],
                ),
                GapSizes.largeGap,
                const OneLineTip(
                  text: 'Next up: create your free GitHub account.',
                ),
                GapSizes.largeGap,
                const ZeroSetupCard(checks: setupChecks),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
