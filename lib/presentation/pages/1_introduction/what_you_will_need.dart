import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/lotties/flutter_lottie.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

part 'need_tile.dart';
part 'nice_to_have_chip.dart';
part 'zero_setup_card.dart';

/// What a student needs before starting: three must-haves as big tiles, two
/// nice-to-haves as chips, and a short "zero setup" card. Kept to a glance.
class WhatYouWillNeed extends StatelessWidget {
  /// The animation in the "Zero setup" card. Tests pass a stand-in, because
  /// the real Lottie loads from the network.
  final Widget setupAnimation;

  const WhatYouWillNeed({
    super.key,
    this.setupAnimation = const FlutterLottie(height: 150),
  });

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

  /// Helpful, but not needed.
  static const niceToHaves = [
    NiceToHaveChip(
      icon: Icons.code_rounded,
      color: Colors.amberAccent,
      label: 'Some Dart & Flutter basics',
    ),
    NiceToHaveChip(
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

  /// Below this width the tiles and the setup card stack.
  static const wideBreakpoint = 900.0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final needsAndExtras = LayoutBuilder(
      builder: (context, constraints) {
        final tilesInARow = constraints.maxWidth >= 540;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tilesInARow)
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
              )
            else
              for (final (i, tile) in needs.indexed) ...[
                if (i > 0) GapSizes.mediumGap,
                tile,
              ],
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
                ...niceToHaves,
              ],
            ),
            GapSizes.largeGap,
            const OneLineTip(text: 'Next up: create your free GitHub account.'),
          ],
        );
      },
    );

    final setupCard = ZeroSetupCard(
      animation: setupAnimation,
      checks: setupChecks,
    );

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
            child: LayoutBuilder(
              builder: (context, constraints) =>
                  constraints.maxWidth >= wideBreakpoint
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: needsAndExtras),
                        GapSizes.xlGap,
                        Expanded(flex: 2, child: setupCard),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [needsAndExtras, GapSizes.largeGap, setupCard],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
