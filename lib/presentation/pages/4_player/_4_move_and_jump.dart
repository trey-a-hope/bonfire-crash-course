import '../../../core/modules/player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_GAME_SCREEN = 'lib/presentation/screens/game_screen.dart';
const _DART_FILE_CHARACTERS_HERO = 'lib/presentation/characters/hero.dart';

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
      outcome: 'A and D walk the hero, and Space double jumps.',
      objective:
          'Move the hero left and right with the A and D keys and double jump with Space.',
      concepts: [
        Concept(
          title: 'Move and Jump',
          short: 'A and D walk, Space jumps, twice in mid-air.',
          subtitle:
              'A and D call onJoystickChangeDirectional to walk left and right, and Space calls jumper.jump(). countJumps lets the hero jump again in mid-air.',
        ),
        Concept(
          title: 'KeyDownEvent and KeyUpEvent',
          short: 'A key was pressed, or a key was let go.',
          subtitle:
              'onKeyboard receives a KeyDownEvent when a key is pressed and a KeyUpEvent when it is released. Releasing A or D either stops the hero or hands control to the other key if it is still held.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add all imports at the top of hero.dart.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
// KeyEvent and LogicalKeyboardKey, for reading key presses.
+ import 'package:flutter/services.dart';
''',
        ),
        CodeStep(
          description: 'Add all imports at the top of game_screen.dart.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
// LogicalKeyboardKey, for the keys the keyboard controller accepts.
+ import 'package:flutter/services.dart';
''',
        ),
        CodeStep(
          description:
              'Add the KeyboardEventListener mixin to the HeroPlayer class.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
- class HeroPlayer extends PlatformPlayer with WithForces {
+ class HeroPlayer extends PlatformPlayer
+     with WithForces, KeyboardEventListener {
  static const _asset = CharacterAsset.wizard;
''',
        ),
        CodeStep(
          description:
              'Add the countJumps property to the player constructor to enable double jumping.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
HeroPlayer(Vector2 position)
    : super(
        position: position,
        ...
        size: Vector2.all(TILE_SIZE),
+         countJumps: 2,
        // Which animation to play for each state and direction.
        animation: PlatformAnimations(
''',
        ),
        CodeStep(
          description:
              'Inside PlatformAnimations, below idleRight, add the jump animations for going up and coming down in each direction.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
animation: PlatformAnimations(
  ...
  idleRight:
      AnimationUtils.loadAnimation(_asset.idleRight, stepTime: 0.2),
+   jump: PlatformJumpAnimations(
+     jumpUpRight:
+         AnimationUtils.loadAnimation(_asset.jumpRight, amount: 6),
+     jumpDownRight:
+         AnimationUtils.loadAnimation(_asset.jumpRight, amount: 6),
+     jumpUpLeft:
+         AnimationUtils.loadAnimation(_asset.jumpLeft, amount: 6),
+     jumpDownLeft:
+         AnimationUtils.loadAnimation(_asset.jumpLeft, amount: 6),
+   ),
),
''',
        ),
        CodeStep(
          description:
              'Below the constructor, override the onKeyboard method. Keys it doesn\'t handle go on to super.onKeyboard.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer
    with WithForces, KeyboardEventListener {
  ...
+   /// Called for every key press and release while the game has focus.
+   @override
+   bool onKeyboard(
+     KeyEvent event,
+     Set<LogicalKeyboardKey> keysPressed,
+   ) {
+     return super.onKeyboard(event, keysPressed);
+   }

  /// Runs once when the hero is added to the game.
  @override
  Future<void> onLoad() async {
''',
        ),
        CodeStep(
          description: 'On key down, make Space jump.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
@override
bool onKeyboard(
  KeyEvent event,
  Set<LogicalKeyboardKey> keysPressed,
) {
+   if (event is KeyDownEvent) {
+     switch (event.logicalKey) {
+       case LogicalKeyboardKey.space:
+         jumper.jump();
+         return true;
+     }
+   }
+
  return super.onKeyboard(event, keysPressed);
}
''',
        ),
        CodeStep(
          description:
              'Below the Space case, make A move left and D move right on key down.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
if (event is KeyDownEvent) {
  switch (event.logicalKey) {
    case LogicalKeyboardKey.space:
      jumper.jump();
      return true;
+     case LogicalKeyboardKey.keyA:
+       onJoystickChangeDirectional(
+         JoystickDirectionalEvent(
+           directional: JoystickMoveDirectional.MOVE_LEFT,
+         ),
+       );
+       return true;
+     case LogicalKeyboardKey.keyD:
+       onJoystickChangeDirectional(
+         JoystickDirectionalEvent(
+           directional: JoystickMoveDirectional.MOVE_RIGHT,
+         ),
+       );
+       return true;
  }
}
''',
        ),
        CodeStep(
          description:
              'After the key down block, stop on key up, unless the other direction key is still held, then walk that way instead.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
if (event is KeyDownEvent) {
  ...
- }
+ } else if (event is KeyUpEvent) {
+   switch (event.logicalKey) {
+     case LogicalKeyboardKey.keyA:
+       onJoystickChangeDirectional(
+         JoystickDirectionalEvent(
+           directional: keysPressed.contains(LogicalKeyboardKey.keyD)
+               ? JoystickMoveDirectional.MOVE_RIGHT
+               : JoystickMoveDirectional.IDLE,
+         ),
+       );
+       return true;
+     case LogicalKeyboardKey.keyD:
+       onJoystickChangeDirectional(
+         JoystickDirectionalEvent(
+           directional: keysPressed.contains(LogicalKeyboardKey.keyA)
+               ? JoystickMoveDirectional.MOVE_LEFT
+               : JoystickMoveDirectional.IDLE,
+         ),
+       );
+       return true;
+   }
+ }

return super.onKeyboard(event, keysPressed);
''',
        ),
        CodeStep(
          description:
              'Register a Keyboard controller on BonfireWidget so the game forwards key presses to the hero.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
@override
Widget build(BuildContext context) {
  return BonfireWidget(
    player: HeroPlayer(Vector2(100, 100)),
+     playerControllers: [
+       Keyboard(
+         config: KeyboardConfig(
+           // The keys the game listens for besides the direction keys.
+           acceptedKeys: [LogicalKeyboardKey.space],
+           directionalKeys: [
+             KeyboardDirectionalKeys.arrows(),
+             KeyboardDirectionalKeys.wasd(),
+           ],
+         ),
+       ),
+     ],
    background: _background,
    ...
  );
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add KeyboardEventListener and the jump animations to HeroPlayer, allow two jumps, handle A, D and Space in onKeyboard, and register a Keyboard controller on BonfireWidget.',
      proTip:
          'Click inside the game window before you press any keys, because key presses only reach the hero while the game has focus.',
    );
  }
}
