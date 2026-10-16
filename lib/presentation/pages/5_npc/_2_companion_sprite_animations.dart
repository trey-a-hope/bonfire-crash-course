import 'package:bonfire_crash_course/core/constants.dart';

import 'npc_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class CompanionSpriteAnimationsPage extends StatelessWidget {
  const CompanionSpriteAnimationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: NPC_MODULE,
      unitStep: 2,
      title: 'Companion Sprite Animations',
      objective:
          'Give the companion idle and walk animations from the strawberry sprite sheets, using the same AnimationUtils helper as the hero.',
      concepts: [
        Concept(
          title: 'SimpleDirectionAnimation',
          subtitle:
              'Holds an NPC\'s idle and run animations for each direction. Bonfire picks the right one from which way the NPC faces and whether it\'s moving.',
        ),
        Concept(
          title: 'Frame Count (amount)',
          subtitle:
              'How many 32x32 frames AnimationUtils slices from a sheet. The strawberry idle sheet is a single frame, so it uses amount: 1; the walk sheet has 4.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Pass a SimpleDirectionAnimation to super(...). The strawberry faces the camera, so left and right share the same sheet.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
Companion(Vector2 position)
    : super(
        ... // position, size, life, speed
        // The strawberry faces the camera, so left and right share a sheet.
        animation: SimpleDirectionAnimation(
          idleRight: AnimationUtils.loadAnimation(STRAWBERRY_IDLE, amount: 1),
          idleLeft: AnimationUtils.loadAnimation(STRAWBERRY_IDLE, amount: 1),
          runRight: AnimationUtils.loadAnimation(
            STRAWBERRY_WALK,
            amount: 4,
            stepTime: 0.12,
          ),
          runLeft: AnimationUtils.loadAnimation(
            STRAWBERRY_WALK,
            amount: 4,
            stepTime: 0.12,
          ),
        ),
      );
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to pass a SimpleDirectionAnimation with the strawberry\'s idle and walk sheets to the Companion constructor.',
      proTip:
          'The companion now appears where you spawned it, floating in mid-air; it has no gravity or hitbox yet, and the next lesson fixes that.',
    );
  }
}
