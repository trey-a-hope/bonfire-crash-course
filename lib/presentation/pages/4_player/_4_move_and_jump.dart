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
          'Move the hero left and right with the A and D keys and double jump with Space.',
      concepts: [
        Concept(
          title: 'Move and Jump',
          subtitle:
              'A and D call onJoystickChangeDirectional to walk left and right, and Space calls jumper.jump(). countJumps lets the hero jump again in mid-air.',
        ),
        Concept(
          title: 'KeyDownEvent and KeyUpEvent',
          subtitle:
              'onKeyboard receives a KeyDownEvent when a key is pressed and a KeyUpEvent when it is released. Releasing A or D either stops the hero or hands control to the other key if it is still held.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add KeyboardEventListener mixin to the hero class.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class Hero ... with KeyboardEventListener { ... }
''',
        ),
        CodeStep(
          description:
              'Configure jump animations using PlatformJumpAnimations.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
jump: PlatformJumpAnimations(
  jumpUpRight: AnimationUtils.loadAnimation(_asset.jumpRight, amount: 6),
  jumpDownRight: AnimationUtils.loadAnimation(_asset.jumpRight, amount: 6),
  jumpUpLeft: AnimationUtils.loadAnimation(_asset.jumpLeft, amount: 6),
  jumpDownLeft: AnimationUtils.loadAnimation(_asset.jumpLeft, amount: 6),
),
''',
        ),

        CodeStep(
          description:
              'Add the countJumps property to the player constructor to enable double jumping.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
countJumps: 2,
''',
        ),
        CodeStep(
          description:
              'Override the onKeyboard method. On key down, Space jumps, A moves left, and D moves right.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
@override
bool onKeyboard(
  KeyEvent event,
  Set<LogicalKeyboardKey> keysPressed,
) {
  if (event is KeyDownEvent) {
    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
        jumper.jump();
        return true;
      case LogicalKeyboardKey.keyA:
        onJoystickChangeDirectional(
          JoystickDirectionalEvent(
            directional: JoystickMoveDirectional.MOVE_LEFT,
          ),
        );
        return true;
      case LogicalKeyboardKey.keyD:
        onJoystickChangeDirectional(
          JoystickDirectionalEvent(
            directional: JoystickMoveDirectional.MOVE_RIGHT,
          ),
        );
        return true;
    }
  }

  return super.onKeyboard(event, keysPressed);
}
''',
        ),
        CodeStep(
          description:
              'Handle key up so the hero stops when A or D is released, or keeps walking the other way if the opposite key is still held. Add this branch after the KeyDownEvent block.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
} else if (event is KeyUpEvent) {
  switch (event.logicalKey) {
    case LogicalKeyboardKey.keyA:
      onJoystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: keysPressed.contains(LogicalKeyboardKey.keyD)
              ? JoystickMoveDirectional.MOVE_RIGHT
              : JoystickMoveDirectional.IDLE,
        ),
      );
      return true;
    case LogicalKeyboardKey.keyD:
      onJoystickChangeDirectional(
        JoystickDirectionalEvent(
          directional: keysPressed.contains(LogicalKeyboardKey.keyA)
              ? JoystickMoveDirectional.MOVE_LEFT
              : JoystickMoveDirectional.IDLE,
        ),
      );
      return true;
  }
}
''',
        ),
        CodeStep(
          description:
              'Register a Keyboard controller on BonfireWidget so the game forwards key presses to the hero.',
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
