import 'player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_HERO = 'lib/presentation/characters/hero.dart';

class PlayerAttackRangePage extends StatelessWidget {
  const PlayerAttackRangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 7,
      title: 'Player Attack Range',
      outcome: 'D fires a range attack.',
      objective:
          'Give the hero a close-range melee strike on S and a projectile attack on W, each with its own one-shot animation played on the hero.',
      concepts: [
        Concept(
          title: 'Ranged Attack (attack.range)',
          short: 'Fires a projectile the way the hero faces.',
          codeMatch: 'range',
          subtitle:
              'Fires a flying projectile in the facing direction. It damages the first enemy it hits and is destroyed when it reaches a wall. The projectile uses its own 16x16 sheet.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Create the range attack: play the cast, wait for the release frame, then fire a 16x16 projectile in the facing direction.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
  void _rangeAttack() {
    if (_isAttacking) return;
    _isAttacking = true;

    AnimationUtils.playAttackAnimation(
      attackLeft: RANGE_ATTACK_LEFT,
      attackRight: RANGE_ATTACK_RIGHT,
      animation: animation!,
      direction: hDirection,
      onFinish: () => _isAttacking = false,
    );

    attack.range(
      animation: AnimationUtils.loadAnimation(
        path: hDirection.isLeftSide
            ? _asset.projectileLeft
            : _asset.projectileRight,
        textureSize: Vector2.all(16),
      ),
      size: Vector2.all(16),
      destroySize: Vector2.all(TILE_SIZE),
      direction: hDirection,
      speed: 220,
      damage: 15,
      marginFromOrigin: 8,
      attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
    );
  }
''',
        ),
        CodeStep(
          description:
              'Map W to the range attack and S to the melee attack inside the KeyDownEvent switch in onKeyboard.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
@override
void onJoystickAction(JoystickActionEvent event) {
  if (event.event == ActionEvent.DOWN) {
    if (event.id == LogicalKeyboardKey.keyA) _rangeAttack();
  }
  super.onJoystickAction(event);
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add WithAttack to Hero, register the four attack animations, write a melee attack and a projectile attack, and map them to S and W in onKeyboard.',
      proTip:
          'Tune damage, speed and size to change how the attacks feel, but keep the _isAttacking check at the top of each one so holding a key can\'t fire faster than the animation plays.',
    );
  }
}
