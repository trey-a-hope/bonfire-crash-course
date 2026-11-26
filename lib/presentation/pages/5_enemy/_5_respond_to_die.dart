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

/// The onMount that hooks up _onDie, shared by MinorEnemy and HeroPlayer.
const _ON_MOUNT_SNIPPET = '''@override
void onMount() {
  life.onDieListener(_onDie);
}
''';

/// Enemy lesson 5, "Respond to Die": when life reaches 0, MinorEnemy and
/// HeroPlayer drop their life bar, stop, play the death animation and are
/// removed (the hero skips pauseBehaviors, since it has no behaviors).
/// Routed at `/enemy/respond-to-die` in `lib/core/pane_config.dart`.
class RespondToDiePage extends StatelessWidget {
  const RespondToDiePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: ENEMY_MODULE,
      unitStep: 5,
      title: 'Respond to Die',
      outcome:
          'When the enemy or the hero runs out of life, it stops, plays its death animation and disappears.',
      objective:
          'Listen for death on MinorEnemy and HeroPlayer: drop the life bar, stop moving, play the death animation and remove the character.',
      concepts: [
        Concept(
          title: 'onDieListener',
          short: 'Calls you back when life hits 0.',
          subtitle:
              'Registers a function that Bonfire calls once, when the character\'s life reaches 0.',
        ),
        Concept(
          title: 'pauseBehaviors',
          short: 'Turns off the AI.',
          subtitle:
              'Stops the UseBehavior list from running, so a dead enemy no longer chases, patrols or attacks. The hero has no behaviors, so it skips this.',
        ),
        Concept(
          title: 'removeFromParent',
          short: 'Takes the component out of the game.',
          subtitle:
              'Removes the component from the game. Passing it as onFinish removes the character as soon as its death animation ends.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'In MinorEnemy, add _onDie: drop the life bar, pause the behaviors, stop, and play the death animation once before removing the enemy.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''void _onDie() {
  lifeBar.dispose();
  pauseBehaviors();
  stop();
  animation?.playOnceOther(
    hDirection.isLeftSide ? DEATH_LEFT : DEATH_RIGHT,
    runToTheEnd: true,
    onFinish: removeFromParent,
  );
}
''',
        ),
        CodeStep(
          description:
              'In MinorEnemy\'s onMount, listen for death and call _onDie.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: _ON_MOUNT_SNIPPET,
        ),
        CodeStep(
          description:
              'Copy the exact same _onDie into HeroPlayer, then remove the pauseBehaviors() line. The hero has no behaviors to pause.',
          fileName: _DART_FILE_CHARACTERS_HERO_PLAYER,
          codeSnippet: '''void _onDie() {
  lifeBar.dispose();
  stop();
  animation?.playOnceOther(
    hDirection.isLeftSide ? DEATH_LEFT : DEATH_RIGHT,
    runToTheEnd: true,
    onFinish: removeFromParent,
  );
}
''',
        ),
        CodeStep(
          description:
              'In HeroPlayer\'s onMount, listen for death and call _onDie.',
          fileName: _DART_FILE_CHARACTERS_HERO_PLAYER,
          codeSnippet: _ON_MOUNT_SNIPPET,
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add _onDie to MinorEnemy and HeroPlayer and hook it up in onMount, so each one plays its death animation and leaves the game when its life runs out.',
      proTip:
          'Lower the enemy\'s life to 20 so one melee hit is enough, and watch the whole death play out.',
    );
  }
}
