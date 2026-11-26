import '../../../core/modules/player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_HERO = 'lib/presentation/characters/hero.dart';

class PlayerAttackMeleePage extends StatelessWidget {
  const PlayerAttackMeleePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 6,
      title: 'Player Attack Melee',
      outcome: 'S swings a melee strike',
      objective: '?',
      concepts: [
        Concept(
          title: 'Melee Attack (attack.melee)',
          short: 'A short, invisible hit area beside the hero.',
          subtitle:
              'Spawns a short-lived, invisible damage area beside the hero. Any enemy inside it takes damage and, with withPush enabled, is knocked back. The swing itself is drawn in the hero\'s own attack sheet.',
        ),
        Concept(
          title: 'playOnceOther',
          short: 'Plays an attack once, then goes back to idle.',
          subtitle:
              'Plays an extra animation registered under others once, then returns to the normal idle/run animation. runToTheEnd: true stops walking or landing from cutting the attack short.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the WithAttack mixin to the HeroPlayer class. It gives the hero the attack.melee and attack.range API.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer
-     with WithForces, KeyboardEventListener, ScreenBoundaryChecker {
+     with
+         WithForces,
+         KeyboardEventListener,
+         ScreenBoundaryChecker,
+         WithAttack {
  static const _asset = CharacterAsset.wizard;
''',
        ),
        CodeStep(
          description:
              'Inside PlatformAnimations, below jump, register the two melee attack animations under others. Each plays once, one per direction.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
animation: PlatformAnimations(
  ...
  jump: PlatformJumpAnimations(
    ...
  ),
+   // Attack sheets play once on the hero's body, one per direction.
+   others: {
+     MELEE_ATTACK_LEFT: AnimationUtils.loadAnimation(
+       _asset.attackMeleeLeft,
+       amount: _asset.attackMeleeFrames,
+       stepTime: ATTACK_STEP_TIME,
+       loop: false,
+     ),
+     MELEE_ATTACK_RIGHT: AnimationUtils.loadAnimation(
+       _asset.attackMeleeRight,
+       amount: _asset.attackMeleeFrames,
+       stepTime: ATTACK_STEP_TIME,
+       loop: false,
+     ),
+   },
),
''',
        ),
        CodeStep(
          description:
              'Below _asset, track whether an attack is playing so attacks can\'t be spammed.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
static const _asset = CharacterAsset.wizard;

+ /// True while an attack animation is playing, so attacks can't be spammed
+ /// faster than the hero can swing.
+ bool _isAttacking = false;
''',
        ),
        CodeStep(
          description:
              'At the bottom of the class, add a getter that tells which way the hero faces.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer
    with ... {
  ...
  @override
  void update(double dt) {
    ...
  }

+   /// Whether the hero is facing left (based on the last horizontal move).
+   bool get _isFacingLeft => hDirection.isLeftSide;
}
''',
        ),
        CodeStep(
          description:
              'Below the getter, add a helper that plays an attack animation for the direction the hero faces, and frees the hero to attack again when it ends.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
bool get _isFacingLeft => hDirection.isLeftSide;

+ /// Plays the attack animation for the hero's facing direction on the hero
+ /// itself. `runToTheEnd` keeps walking or landing from cutting it short.
+ void _playAttackAnimation(String leftKey, String rightKey) {
+   _isAttacking = true;
+   animation?.playOnceOther(
+     _isFacingLeft ? leftKey : rightKey,
+     runToTheEnd: true,
+     onFinish: () => _isAttacking = false,
+   );
+ }
''',
        ),
        CodeStep(
          description:
              'Below the helper, create the melee attack: play the swing, then spawn an invisible 32x32 hit area in front of the hero.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
void _playAttackAnimation(String leftKey, String rightKey) {
  ...
}

+ void _meleeAttack() {
+   if (_isAttacking) return;
+   _playAttackAnimation(MELEE_ATTACK_LEFT, MELEE_ATTACK_RIGHT);
+
+   // The swing and sparks are drawn in the hero's own sheet, so the attack
+   // only needs an invisible hitbox in front of the hero (no animation here).
+   attack.melee(
+     damage: 20,
+     size: Vector2.all(TILE_SIZE),
+     direction: _isFacingLeft ? Direction.left : Direction.right,
+     withPush: true,
+     sizePush: 8,
+     attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
+   );
+ }
''',
        ),
        CodeStep(
          description:
              'Map S to the melee attack inside the KeyDownEvent switch in onKeyboard.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
if (event is KeyDownEvent) {
  switch (event.logicalKey) {
    case LogicalKeyboardKey.space:
      jumper.jump();
      return true;
+     case LogicalKeyboardKey.keyS:
+       _meleeAttack();
+       return true;
    case LogicalKeyboardKey.keyA:
      ...
  }
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add WithAttack to HeroPlayer, register the melee attack animations, write a melee attack, and map it to S in onKeyboard.',
      proTip:
          'Tune damage, speed and size to change how the attacks feel, but keep the _isAttacking check at the top of each one so holding a key can\'t fire faster than the animation plays.',
    );
  }
}
