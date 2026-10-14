import 'package:bonfire_crash_course/core/constants.dart';

import 'player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class CreatePlayerComponentPage extends StatelessWidget {
  const CreatePlayerComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 1,
      title: 'Creating the Player Component',
      objective:
          'Define a custom character component that extends SimplePlayer and configure its visual spritesheet, idle animations, and hitbox in a Bonfire game.',

      concepts: [
        Concept(
          title: 'Player Component',
          subtitle:
              'A custom character component that extends SimplePlayer and configures its visual spritesheet, idle animations, and hitbox in a Bonfire game.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Create a new class named Hero that extends PlatformPlayer to enable side-scroller movement and jumping.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''/// The playable hero character.
///
/// [PlatformPlayer] gives us side-scroller movement and jumping.
class Hero extends PlatformPlayer {
}
''',
        ),
        CodeStep(
          description:
              'Define the Hero constructor, passing the initial spawn position and frame dimensions to the superclass.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
/// Creates the hero at [position] (in pixels from the map's top-left).
Hero(Vector2 position)
    : super(
        position: position,
        // Size on screen; matches one 32x32 frame.
        size: Vector2.all(32),
      );
''',
        ),
        CodeStep(
          description: 'Specify asset for hero class, (wizard, shark, etc.)',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''static const _asset = CharacterAsset.shark;
''',
        ),
        CodeStep(
          description:
              'Configure PlatformAnimations to assign sprite animations for running and idling in left and right directions.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
// Which animation to play for each state and direction.
animation: PlatformAnimations(
  runLeft: AnimationUtils.loadAnimation(_asset.runLeft),
  runRight: AnimationUtils.loadAnimation(_asset.runRight),
  // Idle uses a larger stepTime so it plays slower than walking.
  idleLeft: AnimationUtils.loadAnimation(_asset.idleLeft, stepTime: 0.2),
  idleRight: AnimationUtils.loadAnimation(_asset.idleRight, stepTime: 0.2),
),   
''',
        ),
        CodeStep(
          description:
              'Instantiate Hero with an initial position and pass it to the player property in BonfireWidget.',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
@override
Widget build(BuildContext context) {
  return BonfireWidget(
    player: Hero(Vector2(100, 100)),
  );
}
''',
        ),
      ],
      timeToCodeStatement: 'Approx. 10 minutes',
    );
  }
}
