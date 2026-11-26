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
          subtitle:
              'The enemy version of PlatformPlayer. It moves, jumps and animates the same way, has life that the hero\'s attacks can take away, and is never driven by the keyboard or a joystick.',
        ),
        Concept(
          title: 'components',
          short: 'BonfireWidget\'s list for everything but the player.',
          subtitle:
              'A BonfireWidget list for everything in the world that isn\'t the player, like enemies, allies and decorations. Each entry is placed by its position in pixels from the map\'s top-left.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add all imports at the top of minor_enemy.dart.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
+ import 'package:bonfire/bonfire.dart';
+ import 'package:bonfire_crash_course_playground/core/constants/character_asset.dart';
+ import 'package:bonfire_crash_course_playground/core/constants/globals.dart';
+ import 'package:bonfire_crash_course_playground/core/mixins/screen_boundary_checker.dart';
+ import 'package:bonfire_crash_course_playground/core/utils/sprite_tools.dart';
''',
        ),
        CodeStep(
          description: 'Add all imports at the top of game_screen.dart.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
+ import 'package:bonfire_crash_course_playground/presentation/characters/minor_enemy.dart';
''',
        ),
        CodeStep(
          description:
              'Copy HeroPlayer into minor_enemy.dart and rename it MinorEnemy.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
- class HeroPlayer extends PlatformPlayer { ... }
+ class MinorEnemy extends PlatformEnemy { ... }
''',
        ),
        CodeStep(
          description: 'Rename the constructor to match the class.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
- HeroPlayer(Vector2 position)
+ MinorEnemy(Vector2 position)
    : super(
        position: position,
        size: Vector2.all(TILE_SIZE),
        animation: SpriteTools.buildAnimation(asset: _asset),
      );
''',
        ),
        CodeStep(
          description:
              'Delete the player-only controls: onJoystickAction and _rangeAttack.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
- @override
- void onJoystickAction(JoystickActionEvent event) {
-   ...
- }

- void _rangeAttack() {
-   ...
- }
''',
        ),
        CodeStep(
          description: 'Add the minor enemy to the game.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
return BonfireWidget(
+   components: [ MinorEnemy(Vector2(1000, 100)) ],
);
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
