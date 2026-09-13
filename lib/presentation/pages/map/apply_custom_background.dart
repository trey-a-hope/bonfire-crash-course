import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/lotties/_lotties.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/code_snippet_card.dart';
import 'package:bonfire_crash_course/presentation/widgets/course_video_player.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_outline.dart';
import 'package:flutter/material.dart';

class ApplyCustomBackground extends StatelessWidget implements iPageOutline {
  const ApplyCustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PageOutline(
      title: 'Apply a Custom Background',
      lottie: const MapLottie(),
      objective: Text(
        'A common requirement in 2D games is having background elements—such as a sky or drifting clouds—that scroll continuously on their own, independent of the player\'s movement. In Bonfire, you can easily achieve this inside a GameBackground component by using loadParallaxComponent.',
        style: textTheme.bodyMedium!.copyWith(color: Colors.white),
      ),
      concepts: const [
        Concept(
          title: 'Parallax Background',
          subtitle:
              'A background component that uses loadParallaxComponent to create an auto-scrolling atmospheric background where layered images move continuously without depending on player or camera movement.',
        ),
      ],
      example: [
        // Step 1
        Text(
          'Create a new class that extends the GameBackground class.',
          style: textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        GapSizes.smallGap,
        const CodeSnippetCard(
          fileName: 'parallax_background.dart',
          code: '''
class ParallaxBackground extends GameBackground {
    @override
    Future<void> onLoad() async {
        await super.onLoad();
    }
}
''',
        ),
        GapSizes.mediumGap,

        // Step 2
        Text(
          'Define constant image paths relative to your assets directory to keep asset references organized and reusable. These constants prevent typos and make it easy to manage all your parallax image layers in a single place.',
          style: textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        GapSizes.smallGap,
        const CodeSnippetCard(
          fileName: 'parallax_background.dart',
          code: '''
static const _skyUrl = 'background/sky.png';
static const _cloudsUrl = 'background/clouds.png';
static const _mountainsUrl = 'background/mountains.png';
static const _hillsUrl = 'background/hills.png';
''',
        ),
        GapSizes.mediumGap,

        // Step 3
        Text(
          'Use loadParallaxComponent to create an auto-scrolling atmospheric background where layered images move continuously without depending on player or camera movement. By configuring baseVelocity and velocityMultiplierDelta, you make foreground clouds drift faster than the distant sky to achieve a realistic sense of visual depth.',
          style: textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        GapSizes.smallGap,
        const CodeSnippetCard(
          fileName: 'parallax_background.dart',
          code: '''
// 1. Static/auto-scrolling background layers
final skyAndClouds = await loadParallaxComponent(
    [
          ParallaxImageData(_skyUrl),
        ParallaxImageData(_cloudsUrl),
    ],
    baseVelocity: Vector2(10, 0),
    velocityMultiplierDelta: Vector2(1.5, 1),
);
''',
        ),
        GapSizes.mediumGap,

        // Step 3
        Text('''
Use loadCameraParallaxComponent to bind background layers directly to camera and player movement, making closer scenery shift realistically 
as the player navigates the world. Setting a higher velocityMultiplierDelta of (3,1).
(3,1) ensures the nearby hills scroll significantly faster than distant mountains, producing a strong 3D depth effect.
''', style: textTheme.bodyMedium!.copyWith(color: Colors.white)),
        GapSizes.smallGap,
        const CodeSnippetCard(
          fileName: 'parallax_background.dart',
          code: '''
// 2. Camera-tracked foreground parallax layers
final mountainsAndHills = await loadCameraParallaxComponent(
  [
    ParallaxImageData(_mountainsUrl),
    ParallaxImageData(_hillsUrl),
  ],
  baseVelocity: Vector2(10, 0),
  velocityMultiplierDelta: Vector2(3, 1),
);
''',
        ),
        GapSizes.mediumGap,

        Row(
          children: [
            const Spacer(),
            AdaptiveButton(
              type: AdaptiveButtonType.filled,
              onPressed: () {
                CourseVideoPlayer.showModal(
                  context,
                  videoUrl: videoUrl,
                  title: 'Course Lesson Video',
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded),
                  SizedBox(width: 8),
                  Text('Watch Video Lesson'),
                ],
              ),
            ),
          ],
        ),
      ],
      yourTurn: Text(
        'Open lib/game/game_view.dart in your Codespace. Replace the placeholder container inside BonfireWidget with WorldMapByTiled, point the loader to maps/starter_map.tmx, and verify the map renders in your live preview.',
        style: textTheme.bodyMedium!.copyWith(color: Colors.white),
      ),
    );
  }

  @override
  String get videoUrl =>
      'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4';
}

// Recommended Course Structure
// 1. Getting Started & Setup

// Welcome & Overview: What Bonfire is, architecture (Flame + Bonfire wrappers), and the final game demo.

// Environment Setup: Codespaces walkthrough, folder structure (assets/, lib/), and dependency setup in pubspec.yaml.

// The Game Canvas: Initializing BonfireWidget inside a Flutter Scaffold and understanding core parameters (map, player, cameraConfig).

// 2. World & Map Design

// Introduction to Tiled: Creating tilemaps, layers (ground, above, decorations), and object layers.

// Loading the Map: Implementing WorldMapByTiled and loading .tmx maps and tilesets in Flutter.

// Collisions & Obstacles: Setting collision boxes in Tiled vs. Bonfire code.

// Alternative Maps (Brief): Matrix/custom grid maps (extending WorldMap).

// 3. The Player Character

// Player Spritesheets: Loading idle, run, and attack animations using SpriteAnimation.

// Player Component: Creating a custom class extending SimplePlayer.

// Movement & Controls: Configuring virtual joysticks, keyboard inputs, and directional movement logic.

// Camera Follow: Locking the viewport to the player with smooth tracking and zoom boundaries.

// 4. Enemies & NPC AI

// Enemy Component: Building custom enemies using SimpleEnemy.

// Sensor & Sight: Adding seeAndMoveToPlayer to track and chase the player.

// Patrol Logic: Setting pathfinding or idle patrol routes when the player is out of range.

// Friendly NPCs: Implementing passive dialogue triggers with interactive hitboxes.

// 5. Combat & Interactions

// Attacks & Projectiles: Melee slicing animations (executeMeleeAttack) and ranged projectiles (executeShootSkill).

// Health & Life Management: Configuring receiveDamage, rendering health bars (FlyingDamageText, overhead bars).

// Death & Respawn: Handling die() methods, despawn animations, and game-over states.

// 6. Polishing & Advanced Features

// Lighting & Shaders: Adding ambient darkness, torches, and dynamic radial lighting via Bonfire's lighting engine.

// Interface & HUD: Overlaying Flutter UI elements on top of the game canvas (inventory, health gauges, pause menu).

// Audio & Juice: Hooking up sound effects and background music via flame_audio.

// Standard Lesson Layout Pattern
// To keep the "code-along" experience seamless in your Flutter app, structure each lesson view consistently:

// Objective: 1–2 sentences explaining what mechanic they are building.

// Concepts: Brief explanation of the Bonfire APIs introduced (e.g., SimplePlayer, Direction).

// Step-by-Step Code Snippets: Scaffolded code showing exact changes to make in their Codespace file.

// Checkpoint: What visual result or interaction to verify in their running app before moving to the next section.
