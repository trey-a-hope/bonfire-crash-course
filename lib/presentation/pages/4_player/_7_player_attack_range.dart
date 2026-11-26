import '../../../core/modules/player_module.dart';
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
          subtitle:
              'Fires a flying projectile in the facing direction. It damages the first enemy it hits and is destroyed when it reaches a wall. The projectile uses its own 16x16 sheet.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Inside the others map, below the melee animations, register the two range attack animations.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
others: {
  MELEE_ATTACK_LEFT: AnimationUtils.loadAnimation(
    ...
  ),
  MELEE_ATTACK_RIGHT: AnimationUtils.loadAnimation(
    ...
  ),
+   RANGE_ATTACK_LEFT: AnimationUtils.loadAnimation(
+     _asset.attackRangeLeft,
+     amount: _asset.attackRangeFrames,
+     stepTime: ATTACK_STEP_TIME,
+     loop: false,
+   ),
+   RANGE_ATTACK_RIGHT: AnimationUtils.loadAnimation(
+     _asset.attackRangeRight,
+     amount: _asset.attackRangeFrames,
+     stepTime: ATTACK_STEP_TIME,
+     loop: false,
+   ),
},
''',
        ),
        CodeStep(
          description:
              'Below _meleeAttack, create the range attack and play the cast for the direction the hero faces.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
void _meleeAttack() {
  ...
}

+ void _rangeAttack() {
+   if (_isAttacking) return;
+   // Remember the facing now, in case the hero turns while casting.
+   final facingLeft = _isFacingLeft;
+   _playAttackAnimation(RANGE_ATTACK_LEFT, RANGE_ATTACK_RIGHT);
+ }
''',
        ),
        CodeStep(
          description:
              'At the end of _rangeAttack, wait for the release frame, then fire a 16x16 projectile in the facing direction.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
void _rangeAttack() {
  if (_isAttacking) return;
  final facingLeft = _isFacingLeft;
  _playAttackAnimation(RANGE_ATTACK_LEFT, RANGE_ATTACK_RIGHT);

+   // Fire the projectile on the sheet's release frame so it picks up where
+   // the projectile drawn in the hero's hand leaves off.
+   final releaseDelay = Duration(
+     milliseconds:
+         ((_asset.attackRangeReleaseFrame - 1) * ATTACK_STEP_TIME * 1000)
+             .round(),
+   );
+
+   Future.delayed(releaseDelay, () {
+     // No projectile if the hero was removed while casting.
+     if (!isMounted) return;
+     attack.range(
+       // The projectile is its own 16x16 sheet, not the hero's cast sheet.
+       animation: AnimationUtils.loadAnimation(
+         facingLeft ? _asset.projectileLeft : _asset.projectileRight,
+         textureSize: Vector2.all(16),
+       ),
+       size: Vector2.all(16),
+       destroySize: Vector2.all(TILE_SIZE),
+       direction: facingLeft ? Direction.left : Direction.right,
+       speed: 220,
+       damage: 15,
+       marginFromOrigin: 8,
+       attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
+     );
+   });
}
''',
        ),
        CodeStep(
          description:
              'Map W to the range attack inside the KeyDownEvent switch in onKeyboard.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
if (event is KeyDownEvent) {
  switch (event.logicalKey) {
    case LogicalKeyboardKey.space:
      jumper.jump();
      return true;
+     case LogicalKeyboardKey.keyW:
+       _rangeAttack();
+       return true;
    case LogicalKeyboardKey.keyS:
      _meleeAttack();
      return true;
    ...
  }
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to register the range attack animations on HeroPlayer, write a projectile attack, and map it to W in onKeyboard.',
      proTip:
          'Tune damage, speed and size to change how the attacks feel, but keep the _isAttacking check at the top of each one so holding a key can\'t fire faster than the animation plays.',
    );
  }
}
