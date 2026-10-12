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
              'Create a new class named SharkPlayer that extends PlatformPlayer to enable side-scroller movement and jumping.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''/// The playable shark character.
///
/// [PlatformPlayer] gives us side-scroller movement and jumping.
class SharkPlayer extends PlatformPlayer {
}
''',
        ),
        CodeStep(
          description:
              'Define the SharkPlayer constructor, passing the initial spawn position and frame dimensions to the superclass.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''
/// Creates the shark at [position] (in pixels from the map's top-left).
SharkPlayer(Vector2 position)
    : super(
        position: position,
        // Size on screen; matches one 32x32 frame.
        size: Vector2.all(32),
      );
''',
        ),
        CodeStep(
          description:
              'Add a helper method _loadAnimation to load sequenced frames from a sprite sheet into a SpriteAnimation.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''
/// Turns a sprite sheet into a looping animation.
///
/// [stepTime] is how many seconds each frame stays on screen.
static Future<SpriteAnimation> _loadAnimation(
  String path, {
  double stepTime = 0.1,
}) {
  return SpriteAnimation.load(
    path,
    SpriteAnimationData.sequenced(
      // Number of frames in the sheet.
      amount: 4,
      stepTime: stepTime,
      // Size of a single frame.
      textureSize: Vector2.all(32),
    ),
  );
}         
''',
        ),
        CodeStep(
          description:
              'Configure PlatformAnimations to assign sprite animations for running and idling in left and right directions.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''
// Which animation to play for each state and direction.
animation: PlatformAnimations(
  runLeft: _loadAnimation(_walkLeft),
  runRight: _loadAnimation(_walkRight),
  // Idle uses a larger stepTime so it plays slower than walking.
  idleLeft: _loadAnimation(_idleLeft, stepTime: 0.2),
  idleRight: _loadAnimation(_idleRight, stepTime: 0.2),
),      
''',
        ),
        CodeStep(
          description:
              'Instantiate SharkPlayer with an initial position and pass it to the player property in BonfireWidget.',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
@override
Widget build(BuildContext context) {
  return BonfireWidget(
    ...,
    player: SharkPlayer(Vector2(100, 100)),   
  );
}
''',
        ),
      ],
      timeToCodeStatement: 'Approx. 10 minutes',
    );
  }
}
