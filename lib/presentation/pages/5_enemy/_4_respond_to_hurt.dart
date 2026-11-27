import '../../../core/modules/enemy_module.dart';

import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_MINOR_ENEMY =
    'lib/presentation/characters/minor_enemy.dart';
const _DART_FILE_CHARACTERS_HERO_PLAYER =
    'lib/presentation/characters/hero_player.dart';

/// Enemy lesson 4, "Respond to Hurt": registers a damage listener in
/// onMount for MinorEnemy and HeroPlayer that plays the hurt animation once
/// for the direction the character faces. Routed at `/enemy/respond-to-hurt`
/// in `lib/core/pane_config.dart`.
class RespondToHurtPage extends StatelessWidget {
  const RespondToHurtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: ENEMY_MODULE,
      unitStep: 4,
      title: 'Respond to Hurt',
      outcome: 'The enemy and the hero flinch with their hurt animation every time an attack lands.',
      objective: 'Listen for damage on MinorEnemy and HeroPlayer and play the hurt animation for the way each one faces.',
      concepts: [
        Concept(
          title: 'onMount',
          short: 'Runs once the component joins the game.',
          subtitle: 'Called once, when the component has been added to the game. A good place to hook up listeners, because the character\'s life is ready by then. Always call super.onMount() first.',
        ),
        Concept(
          title: 'onReceiveDamageListener',
          short: 'Calls you back on every hit.',
          subtitle: 'Registers a function that Bonfire calls every time the character takes damage, with who attacked, how much damage was done and the attack\'s id.',
        ),
        Concept(
          title: 'playOnceOther',
          short: 'Plays an animation one time.',
          subtitle: 'Plays a one-off animation over the current one, then goes back. runToTheEnd: true keeps walking or idling from cutting it short.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Override onMount in MinorEnemy to listen for damage.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
class MinorEnemy {
+   @override
+   void onMount() {
+     super.onMount();
+     life.onReceiveDamageListener(_onHurt);
+   }
}
''',
        ),
        CodeStep(
          description: 'Add _onHurt to play the hurt animation for the facing direction.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
class MinorEnemy {
+   void _onHurt(AttackOriginEnum attacker, double damage, dynamic identify) {
+     animation?.playOnceOther(
+       hDirection.isLeftSide ? HURT_LEFT : HURT_RIGHT,
+       runToTheEnd: true,
+     );
+   }
}
''',
        ),
        CodeStep(
          description: 'Copy the same onMount and _onHurt into HeroPlayer.',
          fileName: _DART_FILE_CHARACTERS_HERO_PLAYER,
          codeSnippet: '''
class HeroPlayer {
+   @override
+   void onMount() {
+     super.onMount();
+     life.onReceiveDamageListener(_onHurt);
+   }
}
''',
        ),
        CodeStep(
          description: 'Copy the same onMount and _onHurt into HeroPlayer.',
          fileName: _DART_FILE_CHARACTERS_HERO_PLAYER,
          codeSnippet: '''
class HeroPlayer {
+   void _onHurt(AttackOriginEnum attacker, double damage, dynamic identify) {
+     animation?.playOnceOther(
+       hDirection.isLeftSide ? HURT_LEFT : HURT_RIGHT,
+       runToTheEnd: true,
+     );
+   }
}
''',
        ),
      ],
      timeToCodeStatement: 'You\'re about to override onMount in MinorEnemy and HeroPlayer, listen for damage, and play the hurt animation every time either one is hit.',
      proTip: 'Hit the enemy a few times and watch its life bar from the last lesson shrink as it flinches.',
    );
  }
}
