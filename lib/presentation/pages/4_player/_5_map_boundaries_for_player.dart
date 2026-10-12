import 'package:bonfire_crash_course/core/constants.dart';

import 'player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class MapBoundariesForPlayerPage extends StatelessWidget {
  const MapBoundariesForPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 5,
      title: 'Map Boundaries for Player',
      objective:
          'Keep the player on the map and prevent it from falling into the void.',
      concepts: [
        Concept(
          title: 'Map Boundaries',
          subtitle: 'Map Boundaries prevent the player from leaving the map.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the ScreenBoundaryChecker mixin to the SharkPlayer class.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''
class SharkPlayer extends Player with ScreenBoundaryChecker { ... }
''',
        ),
        CodeStep(
          description:
              'Override the update method to keep the player on the map.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''
/// Called every game tick to update the player's state.
@override
void update(double dt) {
  // Pause player logic and movement while a cutscene/cinematic scene is active.
  if (gameRef.sceneBuilderStatus.isRunning) return;
  // Constrain the player to stay within the map/screen boundaries.
  checkBoundaries();
  // Run standard PlatformPlayer animation updates.
  super.update(dt);
}
''',
        ),
      ],
      timeToCodeStatement: 'Approx. 10 minutes',
    );
  }
}
