import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/check_list_item.dart';
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
                    child: GameWindow(webViewBuilder: gameWebViewBuilder),
                  ),
                ),
                GapSizes.largeGap,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Curriculum Modules
                    const Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ModuleCard(
                            stepNumber: '01',
                            icon: Icons.cloud_done_rounded,
                            accentColor: Colors.blueAccent,
                            title: 'Cloud-First Development Setup',
                            description:
                                'Launch your development environment directly in your browser with GitHub Codespaces. Learn how to run, debug, and preview Flutter games with zero local toolchain setup.',
                          ),
                          GapSizes.mediumGap,
                          ModuleCard(
                            stepNumber: '02',
                            icon: Icons.map_rounded,
                            accentColor: Colors.greenAccent,
                            title: 'Tilemaps & World Building',
                            description:
                                'Import Tiled JSON maps into Bonfire, render multiple visual layers, configure collision geometry for walls and obstacles, and create layered parallax backgrounds.',
                          ),
                          GapSizes.mediumGap,
                          ModuleCard(
                            stepNumber: '03',
                            icon: Icons.sports_esports_rounded,
                            accentColor: Colors.orangeAccent,
                            title: 'Player Component & Controls',
                            description:
                                'Build a side-scrolling hero with idle, run, jump, and attack sprite animations, and drive it with keyboard controls for moving, double jumping, and melee and ranged attacks.',
                          ),
                          GapSizes.mediumGap,
                          ModuleCard(
                            stepNumber: '04',
                            icon: Icons.shield_rounded,
                            accentColor: Colors.purpleAccent,
                            title: 'Collisions, Combat & Mechanics',
                            description:
                                'Master precise collision detection, implement melee attacks, hitboxes, character life bars, enemy tracking, and interactive environment items.',
                          ),
                          GapSizes.mediumGap,
                          ModuleCard(
                            stepNumber: '05',
                            icon: Icons.rocket_launch_rounded,
                            accentColor: Colors.tealAccent,
                            title: 'Game Loop, Polish & Deployment',
                            description:
                                'Fine-tune the game loop, camera follow physics, lighting effects, sound integration, and export your finished game for Web, Desktop, and Mobile.',
                          ),
                        ],
                      ),
                    ),
                    GapSizes.largeGap,
                    // Right Column: Project Showcase & Takeaways
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Project Spotlight Card
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
                                      Icons.star_rounded,
                                      color: Colors.amberAccent,
                                      size: 24,
                                    ),
                                    GapSizes.smallGap,
                                    Text(
                                      "What You'll Build",
                                      style: textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                GapSizes.smallGap,
                                Text(
                                  'By the end of this course, you will have constructed a playable 2D Action Adventure RPG featuring interactive maps, fluid character movement, and enemy mechanics.',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    height: 1.5,
                                  ),
                                ),
                                GapSizes.mediumGap,
                                const CheckListItem(
                                  text:
                                      'Tiled map integration with full collision detection',
                                ),
                                const CheckListItem(
                                  text:
                                      '8-directional animated sprites and movement',
                                ),
                                const CheckListItem(
                                  text:
                                      'Parallax multi-layer scenic backgrounds',
                                ),
                                const CheckListItem(
                                  text:
                                      'Clean, extensible Flutter & Flame architecture',
                                ),
                              ],
                            ),
                          ),
                          GapSizes.mediumGap,
                          // Pro Tip Card
                          AppCard.info(
                            title: 'Every lesson is modular',
                            description:
                                'You can follow sequentially or jump directly to specific topics like map loading or keyboard controls.',
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
