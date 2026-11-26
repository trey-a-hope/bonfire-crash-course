import '../../../core/modules/map_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_GAME_SCREEN = 'lib/presentation/screens/game_screen.dart';

class LoadingTheMap extends StatelessWidget {
  const LoadingTheMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      module: MAP_MODULE,
      unitStep: 1,
      title: 'Loading the Map',
      subtitle:
          'Initialize your Bonfire game canvas and load your tilemap world in Flutter.',
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      videoTitle: 'Loading Tilemaps in Bonfire',
      outcome: 'Your map fills the screen and the camera stays on it.',
      objective:
          'Load your exported Spritefusion tilemap into Flutter and render your game world\'s terrain, collidable obstacles, and base graphics on screen using BonfireWidget.',

      concepts: [
        Concept(
          title: 'BonfireWidget',
          short: 'Runs the game loop, camera and components.',
          subtitle:
              'The central orchestrator widget that bridges Flame and Bonfire within your Flutter widget tree, running the 60 FPS game loop, tile culling, physics, components, and camera.',
        ),
        Concept(
          title: 'WorldMapBySpritefusion',
          short: 'Turns map.json into floor tiles and walls.',
          subtitle:
              'Bonfire\'s built-in map loader for Spritefusion maps. It reads map.json and its associated tileset to construct both visual floor tiles and collision boundary grids.',
        ),
        Concept(
          title: 'CameraConfig',
          short: 'Fits the map and keeps the camera on it.',
          subtitle:
              'Configures viewport zoom levels (initialMapZoomFit) and clamps camera movement strictly to the map area (moveOnlyMapArea: true) so players cannot wander into empty space.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Replace the placeholder widget in GameScreen with BonfireWidget and load the map.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
@override
Widget build(BuildContext context) {
    // Bonfire widget that manages the game loop, rendering, and components.
+    return BonfireWidget(
+        map: WorldMapBySpritefusion(
+            WorldMapReader.fromAsset(MAP_ONE),
+        ),
    );
}
''',
        ),
        CodeStep(
          description:
              'Define a CameraConfig to clamp the viewport and adjust the zoom fit.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
// Class use to configure camera behavior.
final _cameraConfig = CameraConfig(
    // Automatic zoom with base some configurations.
    initialMapZoomFit: InitialMapZoomFitEnum.fitHeight,
    // When this true the camera remains within the map area
    moveOnlyMapArea: true,
);

@override
Widget build(BuildContext context) {
    return BonfireWidget(
        cameraConfig: _cameraConfig,
        ... // Other parameters
    );
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to replace the placeholder in game_screen.dart with a BonfireWidget that loads your Spritefusion map, then add a CameraConfig that fits the map to the screen and keeps the camera inside it.',
      proTip:
          'If you save and the map doesn\'t appear, do a hot restart (Shift+R in the terminal) instead of a hot reload, since a running game doesn\'t always reload its world.',
    );
  }
}
