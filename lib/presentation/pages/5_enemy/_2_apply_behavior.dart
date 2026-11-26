import '../../../core/modules/enemy_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_MINOR_ENEMY =
    'lib/presentation/characters/minor_enemy.dart';

/// Enemy lesson 2, "Apply Behavior": gives MinorEnemy an AI with the
/// UseBehavior mixin, a behaviors list and a BCondition that chases and
/// melees a living hero in sight, and patrols otherwise, and switches its
/// melee to AttackOriginEnum.ENEMY so it hurts the hero. Routed at
/// `/enemy/apply-behavior` in `lib/core/pane_config.dart`.
class ApplyBehaviorPage extends StatelessWidget {
  const ApplyBehaviorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: ENEMY_MODULE,
      unitStep: 2,
      title: 'Apply Behavior',
      outcome:
          'The enemy wanders the map, then chases and strikes the hero when they come within 5 tiles.',
      objective:
          'Give MinorEnemy a behavior tree: patrol at random, chase and melee a living hero it can see, and go back to patrolling when the hero is gone.',
      concepts: [
        Concept(
          title: 'UseBehavior',
          short: 'Runs a list of behaviors every frame.',
          subtitle:
              'A Bonfire mixin that gives a component a behaviors list and runs it every frame, top to bottom. The component\'s AI is just that list, with no update code of your own.',
        ),
        Concept(
          title: 'BCondition',
          short: 'If this, do that; otherwise, do something else.',
          subtitle:
              'A behavior that checks its condition every frame. When it returns true, doBehavior runs; when it returns false, doElseBehavior runs. Nest them to build a decision tree.',
        ),
        Concept(
          title: 'BSeeAndMoveToTarget and BRandomMovement',
          short: 'Chase a target in sight, or wander at random.',
          subtitle:
              'BSeeAndMoveToTarget walks toward its target while it is within radiusVision, calls onClose when they touch, and runs doElseBehavior when the target is out of sight. BRandomMovement wanders to random spots up to maxDistance away.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the UseBehavior mixin to the MinorEnemy class, after its other mixins.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
class MinorEnemy extends PlatformEnemy ...
+     with UseBehavior
{ ... }
''',
        ),
        CodeStep(
          description:
              'Override the behaviors getter in MinorEnemy. It starts as an empty list; the next steps fill it.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
class MinorEnemy ... {
  ...
+   /// AI behavior tree, evaluated every frame from top to bottom.
+   ///
+   /// - Player within 5 tiles: chase and melee when adjacent.
+   /// - Player out of sight: patrol.
+   /// - No player, or player is dead: patrol.
+   @override
+   List<Behavior> get behaviors => [];
}
''',
        ),
        CodeStep(
          description:
              'Add a randomMovement getter below behaviors. It is the patrol the enemy falls back to whenever it isn\'t chasing.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
@override
List<Behavior> get behaviors => [];

+ /// Idle patrol: wander up to 4 tiles at half speed.
+ /// A getter, so each use gets its own fresh instance.
+ Behavior get randomMovement => BRandomMovement(
+       speed: speed / 2,
+       maxDistance: (TILE_SIZE * 4),
+     );
''',
        ),
        CodeStep(
          description:
              'Inside the square brackets of the behaviors list, add a BCondition. The next three steps go inside its parentheses.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
@override
List<Behavior> get behaviors => [
+   BCondition()
];
''',
        ),
        CodeStep(
          description:
              'Give the BCondition its condition: true only while the game has a player who is still alive.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
BCondition(
+   // Only engage while there's a living player to target.
+   condition: (dt, component, game) {
+     return game.player != null && game.player?.isDead == false;
+   },
)
''',
        ),
        CodeStep(
          description:
              'Below condition, add doBehavior: what the enemy does while the condition is true. It chases the hero within 5 tiles and melee attacks when it reaches them, or patrols when the hero is out of sight.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
BCondition(
  condition: (dt, component, game) {
    ...
  },
+   // Player within 5 tiles: chase them down,
+   // and melee as soon as we're close enough to touch.
+   // Otherwise, patrol.
+   doBehavior: BSeeAndMoveToTarget(
+     target: gameRef.player!,
+     radiusVision: TILE_SIZE * 5,
+     onClose: (dt, target) => _meleeAttack(),
+     doElseBehavior: randomMovement,
+   ),
)
''',
        ),
        CodeStep(
          description:
              'Below doBehavior, add doElseBehavior: what the enemy does while the condition is false. With no living player to chase, it patrols.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
BCondition(
  condition: (dt, component, game) {
    ...
  },
  doBehavior: BSeeAndMoveToTarget(
    ...
  ),
+   // No player, or the player is dead: patrol.
+   doElseBehavior: randomMovement,
)
''',
        ),
        CodeStep(
          description:
              'In MinorEnemy\'s _meleeAttack, set attackFrom to AttackOriginEnum.ENEMY. The code copied from HeroPlayer still says PLAYER_OR_ALLY, so the enemy\'s strike would never hurt the hero.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          // The "- " line is the attackFrom copied from HeroPlayer's
          // _meleeAttack; the "+ " line replaces it.
          codeSnippet: '''
_meleeAttack(
-       attackFrom: AttackOriginEnum.PLAYER_OR_ALLY,
+       attackFrom: AttackOriginEnum.ENEMY,
)
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add UseBehavior to MinorEnemy, override its behaviors list, write a randomMovement patrol, and build a BCondition that chases and melees a living hero in sight and patrols otherwise, then make its melee an enemy attack.',
      proTip:
          'Change radiusVision to make the enemy notice the hero from farther away or only up close, and change maxDistance in randomMovement to make its patrol wider or tighter.',
    );
  }
}
