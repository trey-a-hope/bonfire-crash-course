import 'package:bonfire_crash_course/core/constants.dart';

import 'npc_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class ApplyGravityAndCollisionToCompanionPage extends StatelessWidget {
  const ApplyGravityAndCollisionToCompanionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: NPC_MODULE,
      unitStep: 3,
      title: 'Apply Gravity and Collision to Companion',
      outcome: 'Berry lands on the ground and stops at walls.',
      objective:
          'Make the companion fall onto the ground and give it a solid shape, so it stands on the map and stops at walls.',
      concepts: [
        Concept(
          title: 'WithCollision',
          short: 'Stops a moving component when it hits something solid.',
          codeMatch: 'WithCollision',
          subtitle:
              'The mixin that makes a moving component stop when it hits something solid. PlatformPlayer already includes it for the hero, but SimpleAlly doesn\'t, so the companion adds it itself.',
        ),
        Concept(
          title: 'WithForces',
          short: 'Lets gravity pull Berry down.',
          codeMatch: 'WithForces',
          subtitle:
              'The same mixin the hero uses. It lets the gravity you set on BonfireWidget pull the companion down every tick until it lands, so the companion needs no gravity code of its own.',
        ),
        Concept(
          title: 'RectangleHitbox',
          short: 'Berry\'s solid shape.',
          codeMatch: 'RectangleHitbox',
          subtitle:
              'The companion\'s solid shape. It lets the companion land on the ground and stop at walls.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the WithCollision and WithForces mixins to the Companion class. WithForces is all it takes for the world\'s gravity to act on it; the companion already starts on the ground, so gravity just keeps it planted there.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// A friendly NPC that stands on the map and talks to the hero.
///
/// [SimpleAlly] is Bonfire's Ally: an NPC on the player's side. Bonfire 4.0
/// has no `PlatformAlly`, so [WithCollision] and [WithForces] give it the
/// same platform behaviour the hero gets from [PlatformPlayer].
class Companion extends SimpleAlly with WithCollision, WithForces { ... }
''',
        ),
        CodeStep(
          description:
              'Override onLoad and add a RectangleHitbox the same size as the companion.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Runs once when the companion is added to the game.
@override
Future<void> onLoad() async {
  // The hitbox is the companion's solid shape: it stands on the ground
  // and stops at walls.
  add(RectangleHitbox(size: size));
  return super.onLoad();
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add the WithCollision and WithForces mixins to Companion and add a RectangleHitbox in onLoad.',
      proTip:
          'Leave out WithCollision and the companion falls straight through the floor even with a hitbox, because nothing tells it to stop moving when it touches the ground. For now the hero bumps into Berry too; lesson 5 lets them pass through each other.',
    );
  }
}
