import 'package:bonfire_crash_course/core/constants.dart';

import 'player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class ApplyCollisionToPlayerPage extends StatelessWidget {
  const ApplyCollisionToPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 3,
      title: 'Apply Collision to Player',
      objective:
          'Apply collision to the player component in a Bonfire game by configuring its shape, size, and physics properties.',
      concepts: [
        Concept(
          title: 'RectangleHitbox',
          subtitle:
              'Defines the collision area of the player component as a rectangle.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'By default, the player doesn’t have a shape for the physics engine to detect. Add a hitbox to give the shark volume.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''
/// Runs once when the shark is added to the game.
@override
Future<void> onLoad() async {
  // The hitbox is the shark's solid shape.
  // Without it, the shark falls straight through the ground.
  add(RectangleHitbox(size: size));
  return super.onLoad();
}
''',
        ),
      ],
      timeToCodeStatement: 'Approx. 10 minutes',
    );
  }
}
