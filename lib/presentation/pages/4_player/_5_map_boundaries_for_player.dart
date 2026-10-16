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
              'Create a ScreenBoundaryChecker mixin that clamps a component\'s position to the map size.',
          fileName: DART_FILE_SCREEN_BOUNDARY_CHECKER,
          codeSnippet: '''
/// Mixin that prevents a [GameComponent] from moving outside the map boundaries.
mixin ScreenBoundaryChecker on GameComponent {
  /// Clamps the component's position within the map edges.
  /// Typically called inside [update].
  void checkBoundaries() {
    // Total dimensions of the active game map.
    final mapSize = gameRef.map.size;

    // Half-width buffer allowing the sprite to align neatly with map edges.
    final collisionBuffer = size.x / 2;

    // Constrain horizontal position within map bounds.
    position.x = position.x.clamp(
      -collisionBuffer,
      mapSize.x - collisionBuffer,
    );

    // Constrain vertical position within map bounds.
    position.y = position.y.clamp(
      -collisionBuffer,
      mapSize.y - collisionBuffer,
    );
  }
}
''',
        ),
        CodeStep(
          description: 'Add the ScreenBoundaryChecker mixin to the Hero class.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class Hero ... with ScreenBoundaryChecker { ... }
''',
        ),
        CodeStep(
          description:
              'Override the update method to keep the player on the map.',
          fileName: DART_FILE_CHARACTERS_HERO,
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
