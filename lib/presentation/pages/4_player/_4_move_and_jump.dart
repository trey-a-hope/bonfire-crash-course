import 'player_module.dart';
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
          codeMatch: 'jump(',
          subtitle:
              'A and D call onJoystickChangeDirectional to walk left and right, and Space calls jumper.jump(). countJumps lets the hero jump again in mid-air.',
        ),
        Concept(
          title: 'KeyDownEvent and KeyUpEvent',
          short: 'A key was pressed, or a key was let go.',
          codeMatch: 'KeyDownEvent',
          subtitle:
              'onKeyboard receives a KeyDownEvent when a key is pressed and a KeyUpEvent when it is released. Releasing A or D either stops the hero or hands control to the other key if it is still held.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add KeyboardEventListener mixin to the hero class.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class Hero ... with KeyboardEventListener { ... }
''',
        ),
        CodeStep(
          description:
              'Configure jump animations using PlatformJumpAnimations.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
animation: SpriteTools.buildAnimations(asset: _asset)
              .copyWith(jump: SpriteTools.buildJumpAnimations(asset: _asset))
''',
        ),

        CodeStep(
          description:
              'Add the countJumps property to the player constructor to enable double jumping.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
countJumps: 2,
''',
        ),
        CodeStep(
          description:
              'Override the onKeyboard method. On key down, Space jumps, A moves left, and D moves right.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
@override
void onJoystickAction(JoystickActionEvent event) {
  if (event.event == ActionEvent.DOWN) {
    if (event.id == LogicalKeyboardKey.space) jumper.jump();
  }
  super.onJoystickAction(event);
}
''',
        ),
        CodeStep(
          description:
              'Register a Keyboard controller on BonfireWidget so the game forwards key presses to the hero.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
playerControllers: [DefaultKeyboard()],
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add KeyboardEventListener and the jump animations to Hero, allow two jumps, handle A, D and Space in onKeyboard, and register a Keyboard controller on BonfireWidget.',
      proTip:
          'Click inside the game window before you press any keys, because key presses only reach the hero while the game has focus.',
    );
  }
}
