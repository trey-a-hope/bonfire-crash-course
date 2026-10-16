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
          'Apply a constant downward gravity force to the hero so it falls and lands like a platformer character.',
      concepts: [
        Concept(
          title: 'WithForces',
          subtitle:
              'A Bonfire mixin that gives a component a forces controller. Forces are applied every game tick, so gravity keeps pulling the hero down until something solid stops it.',
        ),
        Concept(
          title: 'forces.setGravity',
          subtitle:
              'Sets the gravity vector in pixels per second squared. Vector2(0, 300) pulls straight down; a bigger y makes the hero fall faster.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the WithForces mixin to the Hero class to enable applying physical forces.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class Hero extends PlatformPlayer with WithForces { ... }
''',
        ),
        CodeStep(
          description:
              'Give the constructor a body and set gravity there, right after the super(...) call.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
Hero(Vector2 position)
    : super(
        ... // position, size, animation
      ) {
  forces.setGravity(Vector2(0, 300));
}
''',
        ),
      ],
      timeToCodeStatement: 'Approx. 10 minutes',
    );
  }
}
