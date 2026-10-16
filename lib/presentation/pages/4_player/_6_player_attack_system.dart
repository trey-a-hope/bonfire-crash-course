import 'package:bonfire_crash_course/core/constants.dart';

import 'player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class PlayerAttackSystemPage extends StatelessWidget {
  const PlayerAttackSystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 6,
      title: 'Player Attack System',
      objective:
          'Give the hero a close-range melee strike on S and a projectile attack on W, each with its own one-shot animation played on the hero.',
      concepts: [
        Concept(
          title: 'Melee Attack (attack.melee)',
          subtitle:
              'Spawns a short-lived, invisible damage area beside the hero. Any enemy inside it takes damage and, with withPush enabled, is knocked back. The swing itself is drawn in the hero\'s own attack sheet.',
        ),
        Concept(
          title: 'Ranged Attack (attack.range)',
          subtitle:
              'Fires a flying projectile in the facing direction. It damages the first enemy it hits and is destroyed when it reaches a wall. The projectile uses its own 16x16 sheet.',
        ),
        Concept(
          title: 'playOnceOther',
          subtitle:
              'Plays an extra animation registered under others once, then returns to the normal idle/run animation. runToTheEnd: true stops walking or landing from cutting the attack short.',
        ),
        Concept(
          title: 'Release Frame',
          subtitle:
              'The cast sheet shows the projectile leaving the hero\'s hand. CharacterAsset.attackRangeReleaseFrame says which frame that is, and the real projectile is fired after that delay so the hand-off looks seamless.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the WithAttack mixin to the Hero class. It gives the hero the attack.melee and attack.range API.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class Hero extends PlatformPlayer
    with WithForces, KeyboardEventListener, ScreenBoundaryChecker, WithAttack {
  ...
}
''',
        ),
        CodeStep(
          description:
              'Register the attack sheets under others in PlatformAnimations. The animation names and ATTACK_STEP_TIME already ship with the template in globals.dart, frame counts come from CharacterAsset, and loop: false makes each one play once.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
// Attack sheets play once on the hero's body, one per direction.
others: {
  MELEE_ATTACK_LEFT: AnimationUtils.loadAnimation(
    _asset.attackMeleeLeft,
    amount: _asset.attackMeleeFrames,
    stepTime: ATTACK_STEP_TIME,
    loop: false,
  ),
  MELEE_ATTACK_RIGHT: AnimationUtils.loadAnimation(
    _asset.attackMeleeRight,
    amount: _asset.attackMeleeFrames,
    stepTime: ATTACK_STEP_TIME,
    loop: false,
  ),
  RANGE_ATTACK_LEFT: AnimationUtils.loadAnimation(
    _asset.attackRangeLeft,
    amount: _asset.attackRangeFrames,
    stepTime: ATTACK_STEP_TIME,
    loop: false,
  ),
  RANGE_ATTACK_RIGHT: AnimationUtils.loadAnimation(
    _asset.attackRangeRight,
    amount: _asset.attackRangeFrames,
    stepTime: ATTACK_STEP_TIME,
    loop: false,
  ),
},
''',
        ),
        CodeStep(
          description:
              'Track whether an attack is playing so attacks can\'t be spammed, and add a helper that plays the attack for the direction the hero faces.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
/// True while an attack animation is playing, so attacks can't be spammed
/// faster than the hero can swing.
bool _isAttacking = false;

/// Whether the hero is facing left (based on the last horizontal move).
bool get _isFacingLeft => hDirection.isLeftSide;

/// Plays the attack animation for the hero's facing direction on the hero
/// itself. `runToTheEnd` keeps walking or landing from cutting it short.
void _playAttackAnimation(String leftKey, String rightKey) {
  _isAttacking = true;
  animation?.playOnceOther(
    _isFacingLeft ? leftKey : rightKey,
    runToTheEnd: true,
    onFinish: () => _isAttacking = false,
  );
}
''',
        ),
        CodeStep(
          description:
              'Create the melee attack: play the swing, then spawn an invisible 32x32 hit area in front of the hero.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
void _meleeAttack() {
  if (_isAttacking) return;
  _playAttackAnimation(MELEE_ATTACK_LEFT, MELEE_ATTACK_RIGHT);

  // The swing and sparks are drawn in the hero's own sheet, so the attack
  // only needs an invisible hitbox in front of the hero (no animation here).
  attack.melee(
    damage: 20,
    size: Vector2.all(32),
    direction: _isFacingLeft ? Direction.left : Direction.right,
    withPush: true,
    sizePush: 8,
    attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
  );
}
''',
        ),
        CodeStep(
          description:
              'Create the range attack: play the cast, wait for the release frame, then fire a 16x16 projectile in the facing direction.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
void _rangeAttack() {
  if (_isAttacking) return;
  final facingLeft = _isFacingLeft;
  _playAttackAnimation(RANGE_ATTACK_LEFT, RANGE_ATTACK_RIGHT);

  // Fire the projectile on the sheet's release frame so it picks up where
  // the projectile drawn in the hero's hand leaves off.
  final releaseDelay = Duration(
    milliseconds:
        ((_asset.attackRangeReleaseFrame - 1) * ATTACK_STEP_TIME * 1000)
            .round(),
  );

  Future.delayed(releaseDelay, () {
    if (!isMounted) return;
    attack.range(
      // The projectile is its own 16x16 sheet, not the hero's cast sheet.
      animation: AnimationUtils.loadAnimation(
        facingLeft ? _asset.projectileLeft : _asset.projectileRight,
        textureSize: Vector2.all(16),
      ),
      size: Vector2.all(16),
      destroySize: Vector2.all(32),
      direction: facingLeft ? Direction.left : Direction.right,
      speed: 220,
      damage: 15,
      marginFromOrigin: 8,
      attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
    );
  });
}
''',
        ),
        CodeStep(
          description:
              'Map W to the range attack and S to the melee attack inside the KeyDownEvent switch in onKeyboard.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
case LogicalKeyboardKey.keyW:
  _rangeAttack();
  return true;
case LogicalKeyboardKey.keyS:
  _meleeAttack();
  return true;
''',
        ),
      ],
      timeToCodeStatement:
          'Save hero.dart to hot reload, then press S to swing and W to cast. Turn around with A and attack again to check both directions.',
    );
  }
}
