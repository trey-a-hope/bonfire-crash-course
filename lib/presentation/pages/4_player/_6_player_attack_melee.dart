import 'package:bonfire_crash_course/core/config/constants.dart';

import '../../../core/modules/player_module.dart';

import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

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
      objective: 'Give the hero a close-range melee strike on S with a one-shot swing and a hit area in front of it.',
      concepts: [
        Concept(
          title: 'Melee Attack (attack.melee)',
          short: 'A short, invisible hit area beside the hero.',
          subtitle: 'Spawns a short-lived, invisible damage area beside the hero. Any enemy inside it takes damage and, with withPush enabled, is knocked back. The swing itself is drawn in the hero\'s own attack sheet.',
        ),
        Concept(
          title: 'playOnceOther',
          short: 'Plays an attack once, then goes back to idle.',
          subtitle: 'Plays an extra animation registered under others once, then returns to the normal idle/run animation. runToTheEnd: true stops walking or landing from cutting the attack short.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add the WithAttack mixin to HeroPlayer.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
+ class HeroPlayer extends PlatformPlayer ... with WithAttack { ... }
''',
        ),
        CodeStep(
          description:
              'Track whether a swing is playing so attacks can\'t be spammed.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer ... {
+   bool _isAttacking = false;
}
''',
        ),
        CodeStep(
          description: 'Create _meleeAttack and play the swing animation.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer ... {
+   void _meleeAttack() {
+     if (_isAttacking) return;
+     _isAttacking = true;
+     SpriteTools.playAttackAnimation(
+       attackLeft: MELEE_ATTACK_LEFT,
+       attackRight: MELEE_ATTACK_RIGHT,
+       animation: animation!,
+       direction: hDirection,
+       onFinish: () => _isAttacking = false,
+     );
+   }
}
''',
        ),
        CodeStep(
          description: 'Add an invisible melee hitbox in front of the hero.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
void _meleeAttack() {
     if (_isAttacking) return;
     _isAttacking = true;
     SpriteTools.playAttackAnimation(
       attackLeft: MELEE_ATTACK_LEFT,
       attackRight: MELEE_ATTACK_RIGHT,
       animation: animation!,
       direction: hDirection,
       onFinish: () => _isAttacking = false,
     );
     
+   attack.melee(
+     damage: 20,
+     size: Vector2.all(TILE_SIZE),
+     withPush: true,
+     sizePush: 8,
+     attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
+   );
}
''',
        ),
        CodeStep(
          description: 'Map S to the melee attack in onJoystickAction.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
@override
void onJoystickAction(JoystickActionEvent event) {
  if (event.event == ActionEvent.DOWN) {
    if (event.id == LogicalKeyboardKey.space) jumper.jump();
+     if (event.id == LogicalKeyboardKey.keyS) _meleeAttack();
  }
  super.onJoystickAction(event);
}
''',
        ),
      ],
      timeToCodeStatement: 'You\'re about to add WithAttack to Hero, register the four attack animations, write a melee attack and a projectile attack, and map them to S and W in onKeyboard.',
      proTip: 'Tune damage, speed and size to change how the attacks feel, but keep the _isAttacking check at the top of each one so holding a key can\'t fire faster than the animation plays.',
    );
  }
}
