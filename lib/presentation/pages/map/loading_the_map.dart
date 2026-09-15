import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/lotties/_lotties.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/code_snippet_card.dart';
import 'package:bonfire_crash_course/presentation/widgets/course_video_player.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_outline.dart';
import 'package:flutter/material.dart';

class LoadingTheMap extends StatelessWidget implements iPageOutline {
  const LoadingTheMap({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PageOutline(
      title: 'Loading the Map',
      lottie: const MapLottie(),

      objective: Text(
        'Load an exported Tiled map file into your Flutter application and render your game world\'s initial base layers on screen using Bonfire.',
        style: textTheme.bodyMedium!.copyWith(color: Colors.white),
      ),
      concepts: const [
        Concept(
          title: 'WorldMapByTiled',
          subtitle:
              'WorldMapByTiled is Bonfire\'s map loader that parses .tmx data and manages layer rendering, camera culling, and tile asset pipelines.',
        ),
      ],
      steps: [
        Text(
          'To initialize a map, pass a configured WorldMapByTiledLoader instance into the map argument of your BonfireWidget:',
          style: textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        GapSizes.smallGap,
        const CodeSnippetCard(
          fileName: 'main.dart',
          code: '''
BonfireWidget(
    map: WorldMapByTiled(
        WorldMapByTiledLoader(
            asset: 'maps/dungeon_map.tmx',
        ),
    ),
);
''',
        ),
        GapSizes.smallGap,
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
      timeToCodeStatement:
          'In the editor, open the maps/ folder and double-click starter_map.tmx. You should see a 2D grid with walls, a floor, and some decorations. This is your game world.',
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
