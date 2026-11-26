import '../../../core/modules/enemy_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_MINOR_ENEMY =
    'lib/presentation/characters/minor_enemy.dart';
const _DART_FILE_CHARACTERS_HERO = 'lib/presentation/characters/hero.dart';

/// The hurt animations step, shared word for word by MinorEnemy and
/// HeroPlayer: two one-shot sheets added at the end of the others map.
const _HURT_ANIMATIONS_SNIPPET = '''
others: {
  ...
+   // Plays once each time the character is hit, one per direction.
+   HURT_LEFT: AnimationUtils.loadAnimation(
+     _asset.hurtLeft,
+     amount: _asset.hurtFrames,
+     loop: false,
+   ),
+   HURT_RIGHT: AnimationUtils.loadAnimation(
+     _asset.hurtRight,
+     amount: _asset.hurtFrames,
+     loop: false,
+   ),
},
''';

/// The _onHurt step, shared word for word by MinorEnemy and HeroPlayer.
/// onMount from the step before is unmarked context showing where _onHurt
/// goes; only _onHurt is marked as added, so Copy pastes just the method.
const _ON_HURT_SNIPPET = '''
@override
void onMount() {
  super.onMount();
  life.onReceiveDamageListener(_onHurt);
}

+ /// Called every time an attack hits the character.
+ void _onHurt(AttackOriginEnum attacker, double damage, dynamic identify) {
+   animation?.playOnceOther(
+     hDirection.isLeftSide ? HURT_LEFT : HURT_RIGHT,
+     runToTheEnd: true,
+   );
+ }
''';

/// Enemy lesson 4, "Respond to Hurt": registers the hurt animations for
/// MinorEnemy and HeroPlayer, and a damage listener in onMount that plays
/// them once for the direction the character faces. Routed at `/enemy/respond-to-hurt`
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
      outcome:
          'The enemy and the hero flinch with their hurt animation every time an attack lands.',
      objective:
          'Listen for damage on MinorEnemy and HeroPlayer and play the hurt animation for the way each one faces.',
      concepts: [
        Concept(
          title: 'onMount',
          short: 'Runs once the component joins the game.',
          subtitle:
              'Called once, when the component has been added to the game. A good place to hook up listeners, because the character\'s life is ready by then. Always call super.onMount() first.',
        ),
        Concept(
          title: 'onReceiveDamageListener',
          short: 'Calls you back on every hit.',
          subtitle:
              'Registers a function that Bonfire calls every time the character takes damage, with who attacked, how much damage was done and the attack\'s id.',
        ),
        Concept(
          title: 'playOnceOther',
          short: 'Plays an animation one time.',
          subtitle:
              'Plays a one-off animation over the current one, then goes back. runToTheEnd: true keeps walking or idling from cutting it short.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'In the MinorEnemy constructor\'s others map, after the last animation, register the two hurt animations. Each plays once, one per direction.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: _HURT_ANIMATIONS_SNIPPET,
        ),
        CodeStep(
          description:
              'At the bottom of MinorEnemy, override onMount to listen for damage. It calls _onHurt, which you add next.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
class MinorEnemy extends PlatformEnemy
    with
        WithForces,
        ScreenBoundaryChecker,
        WithAttack,
        UseBehavior,
        WithLifeBar {
  ...

+   /// Runs once the enemy is in the game, when its life is ready.
+   @override
+   void onMount() {
+     super.onMount();
+     life.onReceiveDamageListener(_onHurt);
+   }
}
''',
        ),
        CodeStep(
          description:
              'Below onMount, add _onHurt to play the hurt animation for the direction the enemy faces.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: _ON_HURT_SNIPPET,
        ),
        CodeStep(
          description:
              'Register the same two hurt animations at the end of the HeroPlayer constructor\'s others map.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: _HURT_ANIMATIONS_SNIPPET,
        ),
        CodeStep(
          description:
              'At the bottom of HeroPlayer, override onMount the same way.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer
    with
        WithForces,
        KeyboardEventListener,
        ScreenBoundaryChecker,
        WithAttack,
        WithLifeBar {
  ...

+   /// Runs once the hero is in the game, when its life is ready.
+   @override
+   void onMount() {
+     super.onMount();
+     life.onReceiveDamageListener(_onHurt);
+   }
}
''',
        ),
        CodeStep(
          description: 'Below it, copy the exact same _onHurt into HeroPlayer.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: _ON_HURT_SNIPPET,
        ),
      ],
      timeToCodeStatement:
          'You\'re about to override onMount in MinorEnemy and HeroPlayer, listen for damage, and play the hurt animation every time either one is hit.',
      proTip:
          'Hit the enemy a few times and watch its life bar from the last lesson shrink as it flinches.',
    );
  }
}
