import 'package:bonfire_crash_course/core/app_router.dart';
import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:media_kit/media_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'presentation/services/window_service.dart';

late final PackageInfo packageInfo;

Future<void> main() async {
  // Ensure Flutter engine bindings are initialized before async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MediaKit
  MediaKit.ensureInitialized();

  // Set up desktop window properties (size, center, title bar)
  await WindowService.initializeDesktopWindow();

  packageInfo = await PackageInfo.fromPlatform();

  runApp(const DesktopApp());
}

/// Root app widget that selects the design system framework (Fluent UI vs macos_ui) by platform.
class DesktopApp extends StatelessWidget {
  final _title = 'Bonfire Crash Course';
  final _debugShowCheckedModeBanner = false;

  const DesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO (Trey) - Remove macOS/Windows specific code and replace with a single design system.

    // Windows UI implementation using FluentApp
    if (PlatformResolver.isWindows) {
      return fluent.FluentApp.router(
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          scrollbars: false,
        ),
        debugShowCheckedModeBanner: _debugShowCheckedModeBanner,
        title: _title,
        theme: fluent.FluentThemeData(
          brightness: fluent.Brightness.dark,
          accentColor: fluent.Colors.blue,
        ),
        routerConfig: appRouter,
      );
    }

    // macOS UI implementation using MacosApp
    return macos.MacosApp.router(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      debugShowCheckedModeBanner: _debugShowCheckedModeBanner,
      title: _title,
      theme: macos.MacosThemeData(
        brightness: Brightness.dark,
        accentColor: macos.AccentColor.blue,
      ),
      routerConfig: appRouter,
    );
  }
}

/*
  display - Hero text, splash screens, massive numbers, or promotional banner headlines.
  headline - High-emphasis headers marking major sections or screen-level views.
  title - Medium-emphasis text such as app bar titles, card headers, list tiles, and dialog titles.
  body - Longer-form passages of reading text, paragraphs, descriptions, and default form fields.
  label - Actionable text, button labels, tabs, floating chips, and caption badges.
*/

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
