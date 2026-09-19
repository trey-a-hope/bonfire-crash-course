import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/lotties/_lotties.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_outline.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class LoadingTheMap extends StatelessWidget implements iPageOutline {
  const LoadingTheMap({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PageOutline(
      title: 'Loading the Map',
      unitBadge: 'MODULE 3 • MAP & WORLD BUILDING',
      subtitle:
          'Initialize your Bonfire game canvas and load your tilemap world in Flutter.',
      videoUrl: videoUrl,
      videoTitle: 'Loading Tilemaps in Bonfire',
      lottie: const MapLottie(),
      objective: Text(
        'Load your exported Spritefusion tilemap into Flutter and render your game world\'s terrain, collidable obstacles, and base graphics on screen using BonfireWidget.',
        style: textTheme.bodyMedium!.copyWith(color: Colors.white, height: 1.5),
      ),
      concepts: const [
        Concept(
          title: 'BonfireWidget Canvas',
          subtitle:
              'The central orchestrator widget that bridges Flame and Bonfire within your Flutter widget tree, running the 60 FPS game loop, tile culling, physics, components, and camera.',
        ),
        Concept(
          title: 'WorldMapBySpritefusion',
          subtitle:
              'Bonfire\'s built-in map loader for Spritefusion maps. It reads map.json and its associated tileset to construct both visual floor tiles and collision boundary grids.',
        ),
        Concept(
          title: 'CameraConfig',
          subtitle:
              'Configures viewport zoom levels (initialMapZoomFit) and clamps camera movement strictly to the map area (moveOnlyMapArea: true) so players cannot wander into empty space.',
        ),
      ],
      codeSteps: const [
        CodeStep(
          description:
              'Replace the placeholder widget in GameScreen with BonfireWidget and load the map.',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
@override
Widget build(BuildContext context) {
    // Bonfire widget that manages the game loop, rendering, and components.
    return BonfireWidget(
        // Represents the 2D world where game entities interact.
        map: WorldMapBySpritefusion(
            // Load the map asset bundled with your project.
            WorldMapReader.fromAsset('map.json'),
        ),
    );
}
''',
        ),
        CodeStep(
          description:
              'Define a CameraConfig to clamp the viewport and adjust the zoom fit.',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
final _cameraConfig = CameraConfig(
    initialMapZoomFit: InitialMapZoomFitEnum.fitHeight,
    moveOnlyMapArea: true,
);

@override
Widget build(BuildContext context) {
    return BonfireWidget(
        cameraConfig: _cameraConfig,
        map: WorldMapBySpritefusion(
            WorldMapReader.fromAsset('map.json'),
        ),
    );
}
''',
        ),
      ],
      timeToCodeStatement:
          'Open lib/presentation/screens/game_screen.dart in your Codespace or VS Code. Replace the placeholder with BonfireWidget and CameraConfig, then save the file to trigger Hot Reload. You should see your 2D tilemap rendered immediately on screen!',
    );
  }

  @override
  String get videoUrl =>
      'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4';

  @override
  Color get color => Colors.red.shade900;
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
