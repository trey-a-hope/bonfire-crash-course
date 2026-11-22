import 'player_module.dart';
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
          codeMatch: 'melee',
          subtitle:
              'Spawns a short-lived, invisible damage area beside the hero. Any enemy inside it takes damage and, with withPush enabled, is knocked back. The swing itself is drawn in the hero\'s own attack sheet.',
        ),
        Concept(
          title: 'playOnceOther',
          short: 'Plays an attack once, then goes back to idle.',
          codeMatch: 'playOnceOther',
          subtitle:
              'Plays an extra animation registered under others once, then returns to the normal idle/run animation. runToTheEnd: true stops walking or landing from cutting the attack short.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the WithAttack mixin to the Hero class. It gives the hero the attack.melee and attack.range API.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class Hero extends PlatformPlayer ... WithAttack { ... }
''',
        ),
        CodeStep(
          description:
              'Register the attack sheets under others in PlatformAnimations. Frame counts come from CharacterAsset, and loop: false makes each one play once.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
// Attack sheets play once on the hero's body, one per direction.
animation: SpriteTools.buildAnimations(asset: _asset).copyWith(
    jump: SpriteTools.buildJumpAnimations(asset: _asset),
    others: SpriteTools.buildAttackAnimations(asset: _asset),
  ),
''',
        ),
        CodeStep(
          description:
              'Track whether an attack is playing so attacks can\'t be spammed, and add a helper that plays the attack for the direction the hero faces.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
/// True while an attack animation is playing, so attacks can't be spammed
/// faster than the hero can swing.
bool _isAttacking = false;
''',
        ),
        CodeStep(
          description:
              'Create the melee attack: play the swing, then spawn an invisible 32x32 hit area in front of the hero.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
void _meleeAttack() {
  if (_isAttacking) return;
  _isAttacking = true;

  AnimationUtils.playAttackAnimation(
    attackLeft: MELEE_ATTACK_LEFT,
    attackRight: MELEE_ATTACK_RIGHT,
    animation: animation!,
    direction: hDirection,
    onFinish: () => _isAttacking = false,
  );

  // The swing and sparks are drawn in the hero's own sheet, so the attack
  // only needs an invisible hitbox in front of the hero (no animation here).
  attack.melee(
    damage: 20,
    size: Vector2.all(TILE_SIZE),
    withPush: true,
    sizePush: 8,
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
    if (event.id == LogicalKeyboardKey.keyD) _meleeAttack();
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
