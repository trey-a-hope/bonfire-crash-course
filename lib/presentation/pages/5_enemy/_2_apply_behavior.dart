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
          description: 'Add the UseBehavior mixin to MinorEnemy.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
class MinorEnemy extends PlatformEnemy ...
+     with UseBehavior
{ ... }
''',
        ),
        CodeStep(
          description: 'Override the behaviors getter. It starts empty.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
class MinorEnemy ... {
  ...
+   @override
+   List<Behavior> get behaviors => [];
}
''',
        ),
        CodeStep(
          description:
              'Add randomMovement, the patrol the enemy falls back to.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
@override
List<Behavior> get behaviors => [];

+ Behavior get randomMovement => BRandomMovement(
+       speed: speed / 2,
+       maxDistance: (TILE_SIZE * 4),
+     );
''',
        ),
        CodeStep(
          description: 'Add a BCondition inside the behaviors list.',
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
              'Give the BCondition a condition: a living player exists.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
BCondition(
+   condition: (dt, component, game) {
+     return game.player != null && game.player?.isDead == false;
+   },
)
''',
        ),
        CodeStep(
          description: 'Chase and melee the hero within 5 tiles in doBehavior.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
BCondition(
  condition: ...,
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
              'Patrol in doElseBehavior when there is no living player.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
BCondition(
  condition: ...,
  doBehavior: ...,
+   doElseBehavior: randomMovement,
)
''',
        ),
        CodeStep(
          description:
              'Make the enemy\'s melee hurt the hero: set attackFrom to ENEMY.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
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
