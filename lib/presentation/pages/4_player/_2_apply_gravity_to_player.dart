import 'package:bonfire_crash_course/core/constants.dart';

import 'player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class ApplyGravityToPlayerPage extends StatelessWidget {
  const ApplyGravityToPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 2,
      title: 'Apply Gravity to Player',
      objective:
          'Apply gravity to the player component and configure its hitbox and jump physics in a Bonfire game.',
      concepts: [
        Concept(
          title: 'HandleForces',
          subtitle:
              'A method that is called every game tick to apply forces to the player.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the HandleForces mixin to the SharkPlayer class to enable applying physical forces and acceleration.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''
class SharkPlayer extends PlatformPlayer with HandleForces {
}
''',
        ),
        CodeStep(
          description:
              'Call addForce with an AccelerationForce2D to apply downward gravity along the Y-axis.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''
addForce(
  AccelerationForce2D(
    id: 'player_gravity',
    value: Vector2(0, 400),
  ),
);
''',
        ),
      ],
      timeToCodeStatement: 'Approx. 10 minutes',
    );
  }
}
