import 'map_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_PARALLAX_BACKGROUND =
    'lib/presentation/backgrounds/parallax_background.dart';

class CreateParallaxBackground extends StatelessWidget {
  const CreateParallaxBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      module: MAP_MODULE,
      unitStep: 2,
      title: 'Create Parallax Background',
      subtitle:
          'Load a parallax background with multiple scrolling layers to create a dynamic and immersive game environment.',
      outcome: 'A sky drifts on its own behind hills that follow the camera.',
      objective:
          'A common requirement in 2D games is having background elements—such as a sky or drifting clouds—that scroll continuously on their own, independent of the player\'s movement. In Bonfire, you can easily achieve this inside a GameBackground component by using the util.loadParallaxComponent helper.',

      concepts: [
        Concept(
          title: 'GameBackground',
          short: 'The base class for a custom game background.',
          codeMatch: 'GameBackground',
          subtitle:
              'The base class for a custom game background. Extend it to build your own background; Bonfire draws it behind the map and everything else in the game.',
        ),
        Concept(
          title: 'ParallaxComponent',
          short: 'Image layers moving at different speeds, for depth.',
          codeMatch: 'ParallaxComponent?',
          subtitle:
              'A full parallax, several layers of images drawn out on the screen and each layer moves with different velocities to give an effect of depth.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Create a new class that extends the GameBackground class. Title it "ParallaxBackground."',
          fileName: _DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
/// A custom [GameBackground] that renders layered parallax scrolling backgrounds.
class ParallaxBackground extends GameBackground {}
''',
        ),
        CodeStep(
          description: 'Add variables for building the parallax',
          fileName: _DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
/// How fast the back layer slides, per pixel the camera moves.
static const _baseSpeed = 9.4;

/// How much faster each layer slides than the one behind it.
static const _speedMultiplier = 1.6;

/// The cave's layers, back to front
static const _layers = [CAVE_BACK, CAVE_FAR, CAVE_MID, CAVE_NEAR];

/// The four cave layers, in one component that follows the camera.
ParallaxComponent? _cave;
''',
        ),
        CodeStep(
          description:
              'Define an asynchronous helper method to handle loading and mounting the parallax layers.',
          fileName: _DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
/// Asynchronously loads and attaches the parallax components to the background.
void _addParallax() async {}
''',
        ),

        CodeStep(
          description:
              'Inside the addParallax method, define the layers and their velocities',
          fileName: _DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
// How fast the scene scrolls.
final baseVelocity = Vector2(baseSpeed, 0);

// How much faster each layer moves than the one behind it.
final velocityMultiplierDelta = Vector2(speedMultiplier, 1);

// Keep pixel art crisp instead of blurry.
final quality = FilterQuality.none;

// Put it all together into the cave background.
final cave = await util.loadCameraParallaxComponent(
  _layers,
  baseVelocity: baseVelocity,
  velocityMultiplierDelta: velocityMultiplierDelta,
  filterQuality: quality,
);

// Takes the old cave layers out of the background. 
_cave?.removeFromParent();

// Remembers the new component, so the next resize knows which one to remove.
_cave = cave;

// Puts the new layers into the background so they draw.
add(cave);
''',
        ),

        CodeStep(
          description:
              'Invoke _addParallax inside onLoad so the background layers load when the component mounts. It should come after the "await super.onLoad();"',
          fileName: _DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
/// Overrides the default onLoad method to load the parallax layers.
@override
Future<void> onLoad() async {
  await super.onLoad();
  addParallax();
}
''',
        ),

        CodeStep(
          description:
              'Override onGameResize to handle changes whenever the top-level game canvas or window size changes.',
          fileName: _DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
// Called whenever the size of the top-level Canvas changes.
@override
void onGameResize(Vector2 size) {
  super.onGameResize(size);
  // Reload the parallax on resize when not in cutscene/scene building.
  final isRunning = gameRef.sceneBuilderStatus.isRunning;
  if (!isRunning) {
    addParallax();
  }
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
