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
          description: 'Add all imports at the top of game_screen.dart.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
// The MinorEnemy class you're about to create.
+ import 'package:counter_app/presentation/characters/minor_enemy.dart';
''',
        ),
        CodeStep(
          description:
              'Create minor_enemy.dart and paste in everything from hero.dart, imports included. Then rename the class from HeroPlayer to MinorEnemy and change the component type from PlatformPlayer to PlatformEnemy.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
- class HeroPlayer extends PlatformPlayer
+ class MinorEnemy extends PlatformEnemy
    with
        WithForces,
        KeyboardEventListener,
        ScreenBoundaryChecker,
        WithAttack {
  static const _asset = CharacterAsset.wizard;
''',
        ),
        CodeStep(
          description:
              'Rename the constructor from HeroPlayer to MinorEnemy too. The rest of the copied code (_asset, the animations, onLoad and its hitbox, update and the attacks) stays as it is for now.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
/// Creates the enemy at [position] (in pixels from the map's top-left).
- HeroPlayer(Vector2 position)
+ MinorEnemy(Vector2 position)
    : super(
        position: position,
        ...
      );
''',
        ),
        CodeStep(
          description:
              'Remove the KeyboardEventListener mixin. Nothing presses keys for an enemy, and with three mixins left the list fits on one line.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
class MinorEnemy extends PlatformEnemy
-     with
-         WithForces,
-         KeyboardEventListener,
-         ScreenBoundaryChecker,
-         WithAttack {
+     with WithForces, ScreenBoundaryChecker, WithAttack {
''',
        ),
        CodeStep(
          description:
              'Delete onKeyboard, the keyboard handler copied from the hero.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          // Only removed lines, so there is nothing to copy and the Copy
          // button stays hidden.
          codeSnippet: '''
// The keyboard handler. Nothing presses keys for an enemy.
- /// Called for every key press and release while the game has focus.
- @override
- bool onKeyboard(
-   KeyEvent event,
-   Set<LogicalKeyboardKey> keysPressed,
- ) {
-   if (event is KeyDownEvent) {
-     switch (event.logicalKey) {
-       case LogicalKeyboardKey.space:
-         jumper.jump();
-         return true;
-       case LogicalKeyboardKey.keyW:
-         _rangeAttack();
-         return true;
-       case LogicalKeyboardKey.keyS:
-         _meleeAttack();
-         return true;
-       case LogicalKeyboardKey.keyA:
-         onJoystickChangeDirectional(
-           JoystickDirectionalEvent(
-             directional: JoystickMoveDirectional.MOVE_LEFT,
-           ),
-         );
-         return true;
-       case LogicalKeyboardKey.keyD:
-         onJoystickChangeDirectional(
-           JoystickDirectionalEvent(
-             directional: JoystickMoveDirectional.MOVE_RIGHT,
-           ),
-         );
-         return true;
-     }
-   } else if (event is KeyUpEvent) {
-     switch (event.logicalKey) {
-       case LogicalKeyboardKey.keyA:
-         onJoystickChangeDirectional(
-           JoystickDirectionalEvent(
-             directional: keysPressed.contains(LogicalKeyboardKey.keyD)
-                 ? JoystickMoveDirectional.MOVE_RIGHT
-                 : JoystickMoveDirectional.IDLE,
-           ),
-         );
-         return true;
-       case LogicalKeyboardKey.keyD:
-         onJoystickChangeDirectional(
-           JoystickDirectionalEvent(
-             directional: keysPressed.contains(LogicalKeyboardKey.keyA)
-                 ? JoystickMoveDirectional.MOVE_LEFT
-                 : JoystickMoveDirectional.IDLE,
-           ),
-         );
-         return true;
-     }
-   }
-
-   return super.onKeyboard(event, keysPressed);
- }
''',
        ),
        CodeStep(
          description:
              'At the top of minor_enemy.dart, delete the flutter/services.dart import. Only onKeyboard used it.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
// KeyEvent and LogicalKeyboardKey, which only onKeyboard used.
- import 'package:flutter/services.dart';
''',
        ),
        CodeStep(
          description:
              'Delete _rangeAttack. This enemy only uses _meleeAttack.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
// The projectile attack. This enemy only uses _meleeAttack.
- void _rangeAttack() {
-   if (_isAttacking) return;
-   // Remember the facing now, in case the hero turns while casting.
-   final facingLeft = _isFacingLeft;
-   _playAttackAnimation(RANGE_ATTACK_LEFT, RANGE_ATTACK_RIGHT);
-
-   // Fire the projectile on the sheet's release frame so it picks up where
-   // the projectile drawn in the hero's hand leaves off.
-   final releaseDelay = Duration(
-     milliseconds:
-         ((_asset.attackRangeReleaseFrame - 1) * ATTACK_STEP_TIME * 1000)
-             .round(),
-   );
-
-   Future.delayed(releaseDelay, () {
-     // No projectile if the hero was removed while casting.
-     if (!isMounted) return;
-     attack.range(
-       // The projectile is its own 16x16 sheet, not the hero's cast sheet.
-       animation: AnimationUtils.loadAnimation(
-         facingLeft ? _asset.projectileLeft : _asset.projectileRight,
-         textureSize: Vector2.all(16),
-       ),
-       size: Vector2.all(16),
-       destroySize: Vector2.all(TILE_SIZE),
-       direction: facingLeft ? Direction.left : Direction.right,
-       speed: 220,
-       damage: 15,
-       marginFromOrigin: 8,
-       attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
-     );
-   });
- }
''',
        ),
        CodeStep(
          description:
              'In the constructor\'s others map, delete the two range attack animations. Only _rangeAttack played them.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          // Only removed lines, so the Copy button stays hidden.
          codeSnippet: '''
// In the others map, below MELEE_ATTACK_RIGHT.
- RANGE_ATTACK_LEFT: AnimationUtils.loadAnimation(
-   _asset.attackRangeLeft,
-   amount: _asset.attackRangeFrames,
-   stepTime: ATTACK_STEP_TIME,
-   loop: false,
- ),
- RANGE_ATTACK_RIGHT: AnimationUtils.loadAnimation(
-   _asset.attackRangeRight,
-   amount: _asset.attackRangeFrames,
-   stepTime: ATTACK_STEP_TIME,
-   loop: false,
- ),
''',
        ),
        CodeStep(
          description:
              'In game_screen.dart, add a MinorEnemy to BonfireWidget\'s components list, after the camera drag.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
return BonfireWidget(
  ...
-   components: [_cameraDrag],
+   components: [
+     _cameraDrag,
+     MinorEnemy(Vector2(1000, 100)),
+   ],
  ...
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
