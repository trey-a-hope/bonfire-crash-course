import '../../../core/modules/enemy_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_GAME_SCREEN = 'lib/presentation/screens/game_screen.dart';
const _DART_FILE_CHARACTERS_MINOR_ENEMY =
    'lib/presentation/characters/minor_enemy.dart';

/// Enemy lesson 1, "Creating the Enemy Component": turns a copy of the
/// HeroPlayer class into a MinorEnemy that extends PlatformEnemy, then adds
/// it to BonfireWidget's components in game_screen.dart. Routed at
/// `/enemy/enemy-component` in `lib/core/pane_config.dart`.
class CreateEnemyComponentPage extends StatelessWidget {
  const CreateEnemyComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: ENEMY_MODULE,
      unitStep: 1,
      title: 'Creating the Enemy Component',
      outcome: 'A minor enemy stands on the map next to the hero.',
      objective:
          'Reuse the HeroPlayer code to build a MinorEnemy that extends PlatformEnemy, strip out the player-only controls, and add it to the game.',

      concepts: [
        Concept(
          title: 'PlatformEnemy',
          short: 'The enemy twin of PlatformPlayer.',
          codeMatch: 'PlatformEnemy',
          subtitle:
              'The enemy version of PlatformPlayer. It moves, jumps and animates the same way, has life that the hero\'s attacks can take away, and is never driven by the keyboard or a joystick.',
        ),
        Concept(
          title: 'components',
          short: 'BonfireWidget\'s list for everything but the player.',
          codeMatch: 'components:',
          subtitle:
              'A BonfireWidget list for everything in the world that isn\'t the player, like enemies, allies and decorations. Each entry is placed by its position in pixels from the map\'s top-left.',
        ),
      ],
      codeSteps: [
        CodeStep(
          // Shown as plain text, so each "\n• " starts a new bullet line.
          description:
              'Create the MinorEnemy class in minor_enemy.dart from the hero\'s code:'
              '\n• Copy and paste the HeroPlayer into the MinorEnemy.'
              '\n• Change the title from HeroPlayer to MinorEnemy.'
              '\n• Change the component type from PlatformPlayer to PlatformEnemy.'
              '\n• Remove the KeyboardEventListener.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''/// A basic enemy, built from the hero's code without the controls.
///
/// [PlatformEnemy] is the enemy version of [PlatformPlayer].
class MinorEnemy extends PlatformEnemy
    with WithForces, ScreenBoundaryChecker, WithAttack {
  /// Creates the enemy at [position] (in pixels from the map's top-left).
  MinorEnemy(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(TILE_SIZE),
          animation: SpriteTools.buildAnimation(asset: _asset),
        );

  // The rest stays as it was copied from HeroPlayer for now: _asset, onLoad
  // and its hitbox, _isAttacking, _meleeAttack, _rangeAttack and
  // onJoystickAction. The next step deletes the last two.
  ...
}
''',
        ),
        CodeStep(
          // Shown as plain text, so each "\n• " starts a new bullet line.
          description:
              'Remove the player-only controls that MinorEnemy no longer needs:'
              '\n• Delete onJoystickAction.'
              '\n• Delete the _rangeAttack.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          // Mirrors the signatures from the Player lessons so the learner can
          // spot both members in the copied code.
          codeSnippet: '''class MinorEnemy extends PlatformEnemy
    with WithForces, ScreenBoundaryChecker, WithAttack {
  ...

  // Delete: the joystick and keyboard handler. Nothing presses keys for
  // an enemy.
  @override
  void onJoystickAction(JoystickActionEvent event) {
    ...
  }

  // Delete: the projectile attack. This enemy only uses _meleeAttack.
  void _rangeAttack() {
    ...
  }
}
''',
        ),
        CodeStep(
          description: 'Add the minor enemy to the game.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''components: [ MinorEnemy(Vector2(1000, 100)) ],
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to copy HeroPlayer into minor_enemy.dart, turn it into a MinorEnemy that extends PlatformEnemy, remove the keyboard and joystick code and the range attack, and add a MinorEnemy to BonfireWidget\'s components.',
      proTip:
          'Change the CharacterAsset in MinorEnemy (for example to CharacterAsset.shark) so the enemy doesn\'t look exactly like your hero.',
    );
  }
}
