import 'player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_GAME_SCREEN = 'lib/presentation/screens/game_screen.dart';
const _DART_FILE_CHARACTERS_HERO = 'lib/presentation/characters/hero.dart';

class ApplyGravityToPlayerPage extends StatelessWidget {
  const ApplyGravityToPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 2,
      title: 'Apply Gravity to Player',
      outcome: 'The hero falls, pulled down by gravity.',
      objective:
          'Turn on gravity for the whole game, then let it pull the hero down so it falls and lands like a platformer character.',
      concepts: [
        Concept(
          title: 'WithForces',
          short: 'Lets gravity act on the hero every tick.',
          codeMatch: 'WithForces',
          subtitle:
              'A Bonfire mixin that lets forces act on a component. Forces are applied every game tick, so gravity keeps pulling the hero down until something solid stops it.',
        ),
        Concept(
          title: 'globalForces',
          short: 'Gravity for the whole game, set once.',
          codeMatch: 'globalForces',
          subtitle:
              'Set on BonfireWidget once, it pulls on every component with WithForces. GlobalForcesSettings(gravity: Vector2(0, GRAVITY)) pulls straight down at 300 pixels per second squared; a bigger number makes everything fall faster.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Pass globalForces to BonfireWidget in game_screen.dart to turn on gravity for the whole game.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
return BonfireWidget(
  // Gravity for the whole game. It pulls on every character with the
  // WithForces mixin (the hero, the companion and the foe).
  globalForces: GlobalForcesSettings(gravity: Vector2(0, GRAVITY))
);
''',
        ),
        CodeStep(
          description:
              'Add the WithForces mixin to the Hero class so the world\'s gravity acts on it.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class Hero ... with WithForces { ... }
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to turn on gravity for the whole game with globalForces on BonfireWidget, and add the WithForces mixin to Hero.',
      proTip:
          'Don\'t worry if the hero now falls straight through the floor; it has no solid shape yet, and the hitbox in the next lesson fixes that. Bonfire also has forces.setGravity for a single character, but don\'t use it on top of globalForces: the two add up, and that character falls twice as fast.',
    );
  }
}
