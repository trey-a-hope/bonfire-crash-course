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
          'A common requirement in 2D games is having background elements—such as a sky or drifting clouds—that scroll continuously on their own, independent of the player\'s movement. In Bonfire, you can easily achieve this inside a GameBackground component by using the util.loadParallaxComponent helper.',

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
              'Use util.loadParallaxComponent to create an auto-scrolling layer for the sky and clouds that moves continuously across the screen, then add it to the component.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
// Load sky and clouds with independent horizontal motion
_skyAndClouds = await util.loadParallaxComponent(
  [
    ParallaxImageData(SKY),
    ParallaxImageData(CLOUDS),
  ],
  baseVelocity: Vector2(10, 0),
  velocityMultiplierDelta: Vector2(1.5, 1),
);

add(_skyAndClouds!);
''',
        ),

        CodeStep(
          description:
              'Use util.loadCameraParallaxComponent to load mountains and hills layers that react to camera movement for visual depth perspective, then add it to the component.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
// Load mountains and hills attached to camera motion for depth perspective
_mountainsAndHills = await util.loadCameraParallaxComponent(
  [
    ParallaxImageData(MOUNTAINS),
    ParallaxImageData(HILLS),
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
  ...;
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
          'You\'re about to create a ParallaxBackground class in parallax_background.dart with a sky layer that scrolls on its own and a hills layer that follows the camera, then pass it to BonfireWidget\'s background.',
      proTip:
          'Layers draw in the order you add them, so add the far-away sky first and the closer hills after it, or the hills will be hidden behind the sky.',
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
    );
  }
}
