import 'package:bonfire_crash_course/core/constants.dart';

import 'player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class MoveAndJumpPage extends StatelessWidget {
  const MoveAndJumpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 4,
      title: 'Move and Jump',
      objective:
          'Move the shark left and right using the arrow keys and implement double jumping.',
      concepts: [
        Concept(
          title: 'Move and Jump',
          subtitle:
              'Movement is handled by the keyboard controller, and jumping is handled by the platformer physics engine.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Configure jump animations using PlatformJumpAnimations.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''
jump: PlatformJumpAnimations(
  jumpUpRight: AnimationUtils.loadAnimation(SHARK_JUMP_RIGHT, amount: 6),
  jumpDownRight:
      AnimationUtils.loadAnimation(SHARK_JUMP_RIGHT, amount: 6),
  jumpUpLeft: AnimationUtils.loadAnimation(SHARK_JUMP_LEFT, amount: 6),
  jumpDownLeft: AnimationUtils.loadAnimation(SHARK_JUMP_LEFT, amount: 6),
),
''',
        ),

        CodeStep(
          description:
              'Add the countJumps property to the player constructor to enable double jumping.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''
countJumps: 2,
''',
        ),
        CodeStep(
          description:
              'Override the onKeyboard method to handle keyboard input.',
          fileName: DART_FILE_SHARK_PLAYER,
          codeSnippet: '''
@override
bool onKeyboard(
  KeyEvent event,
  Set<LogicalKeyboardKey> keysPressed,
) {
  if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
    jump();
    return true; // Handled
  }

  return super.onKeyboard(event, keysPressed);
}
''',
        ),
        CodeStep(
          description:
              'Override the onKeyboard method to handle keyboard input.',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
playerControllers: [
  // Here you enable receive keyboard interaction
  Keyboard(
    config: KeyboardConfig(
      enable:
          true, // Use to enable or disable keyboard events (default is true)
      acceptedKeys: [
        // You can pass specific Keys accepted. If null accept all keys
        LogicalKeyboardKey.space,
      ],
      directionalKeys: [
        KeyboardDirectionalKeys.arrows(),
        KeyboardDirectionalKeys.wasd(),
      ], // Type of the directional (arrows or wasd)
    ),
  )
],
''',
        ),
      ],
      timeToCodeStatement: 'Approx. 10 minutes',
    );
  }
}
