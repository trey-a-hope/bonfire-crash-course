import 'player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_HERO = 'lib/presentation/characters/hero.dart';

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
      outcome: 'The hero can\'t walk or fall off the map.',
      objective:
          'Keep the player on the map and prevent it from falling into the void.',
      concepts: [
        Concept(
          title: 'Map Boundaries',
          short: 'Keeps the hero inside the map.',
          codeMatch: 'checkBoundaries',
          subtitle: 'Map Boundaries prevent the player from leaving the map.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add the ScreenBoundaryChecker mixin to the Hero class.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class Hero ... with ScreenBoundaryChecker { ... }
''',
        ),
        CodeStep(
          description:
              'Override the update method to keep the player on the map.',
          fileName: _DART_FILE_CHARACTERS_HERO,
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
      timeToCodeStatement:
          'You\'re about to add the ScreenBoundaryChecker mixin to Hero and override update so it calls checkBoundaries() every tick.',
      proTip:
          'Keep super.update(dt) as the last line of update; without it the hero stops moving and animating.',
    );
  }
}
