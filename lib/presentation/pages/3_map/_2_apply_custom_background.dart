import 'package:bonfire_crash_course/core/constants.dart';
import 'map_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class ApplyCustomBackground extends StatelessWidget {
  const ApplyCustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      module: MAP_MODULE,
      unitStep: 2,
      title: 'Apply a Custom Background',
      subtitle:
          'Load a parallax background with multiple scrolling layers to create a dynamic and immersive game environment.',
      objective:
          'A common requirement in 2D games is having background elements—such as a sky or drifting clouds—that scroll continuously on their own, independent of the player\'s movement. In Bonfire, you can easily achieve this inside a GameBackground component by using loadParallaxComponent.',

      concepts: [
        Concept(
          title: 'GameBackground',
          subtitle: 'Base to create your custom game background',
        ),
        Concept(
          title: 'ParallaxComponent',
          subtitle:
              'A full parallax, several layers of images drawn out on the screen and each layer moves with different velocities to give an effect of depth.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Create a new class that extends the GameBackground class. Title it "ParallaxBackground."',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
/// A custom [GameBackground] that renders layered parallax scrolling backgrounds.
class ParallaxBackground extends GameBackground {
  // Load assets for the background.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }
}
''',
        ),
        CodeStep(
          description:
              'Define constant image paths relative to your assets directory to keep asset references organized and reusable.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
// Asset paths for background layers
static const _sky = 'background/sky.png';
static const _clouds = 'background/clouds.png';
static const _mountains = 'background/mountains.png';
static const _hills = 'background/hills.png';
''',
        ),
        CodeStep(
          description:
              'Declare nullable ParallaxComponent fields to hold references to your sky/clouds and mountains/hills background layers.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
/// Parallax layer for constant auto-scrolling sky and clouds.
ParallaxComponent? _skyAndClouds;
/// Parallax layer for camera-tracked mountains and hills.
ParallaxComponent? _mountainsAndHills;
''',
        ),

        CodeStep(
          description:
              'Define an asynchronous helper method named _addParallax to handle loading and mounting the parallax layers.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
/// Asynchronously loads and attaches the parallax components to the background.
void _addParallax() async {}
''',
        ),

        CodeStep(
          description:
              'Use loadParallaxComponent to create an auto-scrolling layer for the sky and clouds that moves continuously across the screen, then add it to the component.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
// Load sky and clouds with independent horizontal motion
_skyAndClouds = await loadParallaxComponent(
  [
    ParallaxImageData(_sky),
    ParallaxImageData(_clouds),
  ],
  baseVelocity: Vector2(10, 0),
  velocityMultiplierDelta: Vector2(1.5, 1),
);

add(_skyAndClouds!);
''',
        ),

        CodeStep(
          description:
              'Use loadCameraParallaxComponent to load mountains and hills layers that react to camera movement for visual depth perspective, then add it to the component.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
// Load mountains and hills attached to camera motion for depth perspective
_mountainsAndHills = await loadCameraParallaxComponent(
  [
    ParallaxImageData(_mountains),
    ParallaxImageData(_hills),
  ],
  baseVelocity: Vector2(10, 0),
  velocityMultiplierDelta: Vector2(3, 1),
);

add(_mountainsAndHills!);
''',
        ),

        CodeStep(
          description:
              'Invoke _addParallax inside onLoad so the background layers load when the component mounts. It should come after the "await super.onLoad();"',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
@override
Future<void> onLoad() async {
  ...
  _addParallax();
}
''',
        ),

        CodeStep(
          description:
              'Override onGameResize to handle changes whenever the top-level game canvas or window size changes.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
@override
// Called whenever the size of the top-level Canvas changes.
void onGameResize(Vector2 size) {
  super.onGameResize(size);
}
''',
        ),

        CodeStep(
          description:
              'Re-initialize parallax components on resize when not in cutscene/scene building by removing existing layers and re-adding them.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
// Re-initialize parallax components on resize when not in cutscene/scene building
if (!gameRef.sceneBuilderStatus.isRunning) {
  _skyAndClouds?.removeFromParent();
  _mountainsAndHills?.removeFromParent();
  _addParallax();
}
''',
        ),

        CodeStep(
          description:
              'Pass an instance of ParallaxBackground to the background parameter of BonfireWidget to render the parallax background behind your game world.',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
@override
Widget build(BuildContext context) {
  return BonfireWidget(
    ...,
    background: ParallaxBackground(),
  );
}
''',
        ),
      ],
      timeToCodeStatement:
          'Now it\'s your turn to build the atmosphere! Head over to parallax_background.dart to create your ParallaxBackground class, assemble the layered scrolling components, and plug it into your BonfireWidget.',
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
    );
  }
}
