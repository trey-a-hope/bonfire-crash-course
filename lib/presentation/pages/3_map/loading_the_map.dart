import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/unit_datas.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_outline.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class LoadingTheMap extends StatelessWidget implements iPageOutline {
  const LoadingTheMap({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PageOutline(
      unitName: 'Map',
      unitStep: 1,
      unitTotalSteps: 2,
      color: UnitDatas.mapUnitData.accentColor,
      title: 'Loading the Map',
      subtitle:
          'Initialize your Bonfire game canvas and load your tilemap world in Flutter.',
      videoUrl: videoUrl,
      videoTitle: 'Loading Tilemaps in Bonfire',
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
          'Open lib/presentation/screens/game_screen.dart in your Codespace or VS Code. Replace the placeholder with BonfireWidget and CameraConfig, then save the file to trigger Hot Reload. You should see your 2D tilemap rendered immediately on screen!',
    );
  }

  @override
  String get videoUrl =>
      'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4';

  @override
  Color get color => Colors.red.shade900;
}
