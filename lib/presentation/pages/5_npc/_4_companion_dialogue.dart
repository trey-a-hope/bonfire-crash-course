import 'npc_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_COMPANION =
    'lib/presentation/characters/companion.dart';

class CompanionDialoguePage extends StatelessWidget {
  const CompanionDialoguePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: NPC_MODULE,
      unitStep: 4,
      title: 'Companion Dialogue',
      outcome: 'Berry talks to the hero once, when they come close.',
      objective:
          'Make the companion talk when the hero comes close: watch for the hero with vision.seePlayer, pause the game, and show a TalkDialog once, with the strawberry\'s talking face beside each line.',
      concepts: [
        Concept(
          title: 'vision.seePlayer',
          short: 'Checks whether the hero is close enough.',
          codeMatch: 'seePlayer',
          subtitle:
              'Checks every tick whether the hero is within radiusVision pixels. observed runs while the hero is in range and notObserved runs while they\'re out of it.',
        ),
        Concept(
          title: 'TalkDialog and Say',
          short: 'Bonfire\'s dialogue box and its lines.',
          codeMatch: 'TalkDialog',
          subtitle:
              'Bonfire\'s built-in dialogue box. TalkDialog.show takes a list of Say lines, types each one out, and moves on when the player presses a key or taps.',
        ),
        Concept(
          title: 'pauseEngine and resumeEngine',
          short: 'Freezes the game while you talk.',
          codeMatch: 'Engine()',
          subtitle:
              'Freeze and restart the game loop. Pausing before the dialogue opens stops the hero from walking off mid-conversation, and keeps a hero in mid-jump from falling through the ground if opening it stalls the app for a moment.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the fields the dialogue needs at the top of the Companion class: how close the hero must be, and whether the companion has already talked. _hasTalked never resets, so the dialogue opens only once.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// How close (in pixels) the hero must be before the companion talks.
static const _talkRadius = 48.0;

/// True once the companion has talked. It never resets: the dialogue opens
/// only once, and after it the companion follows the hero.
bool _hasTalked = false;
''',
        ),
        CodeStep(
          description:
              'Override update and check for the hero with vision.seePlayer. observed runs every tick the hero is in range, so _talk returns early once it has talked.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Called every game tick to check whether the hero is close.
@override
void update(double dt) {
  vision.seePlayer(
    radiusVision: _talkRadius,
    observed: (_) => _talk(),
  );
  super.update(dt);
}
''',
        ),
        CodeStep(
          description:
              'Write _talk: stop the hero, pause the game right away, and show the dialogue. onClose resumes the game when the last line is done.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: r'''
/// Pauses the game and opens the dialogue (only once).
void _talk() {
  if (_hasTalked) return;
  _hasTalked = true;

  gameRef.player?.onJoystickChangeDirectional(
    JoystickDirectionalEvent(directional: JoystickMoveDirectional.IDLE),
  );

  // Freeze the game right away, before the dialogue opens. Opening it can
  // stall the app for a moment; if the game kept running, that stall would
  // become one huge physics step and a hero in mid-jump could fall
  // straight through the ground.
  gameRef.pauseEngine();

  TalkDialog.show(
    context,
    [
      _say('Oh, hi there! I\'m Berry.'),
      _say('Watch your step, the hills around here are tricky.'),
      _say('Mind if I tag along?'),
    ],
    onClose: gameRef.resumeEngine,
  );
}
''',
        ),
        CodeStep(
          description:
              'Write _say, which builds one line of dialogue with a face beside it, shown at 96px (three times the sprite) so it is easy to see. The face is a widget, so later lines can swap in another one; by default it is the talking face. Add an import for package:flutter/material.dart at the top of companion.dart for TextSpan, SizedBox and Widget.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// One line of dialogue, with the companion's [face] beside it (its
/// talking face unless another is given).
Say _say(String text, {Widget face = _talkingFace}) {
  return Say(
    text: [TextSpan(text: text)],
    // 96px, three times the sprite's size, so it is easy to see.
    person: SizedBox.square(dimension: 96, child: face),
  );
}
''',
        ),
        CodeStep(
          description:
              'Below the Companion class, write _Face: a widget that plays one of the strawberry sheets with SpriteAnimationWidget.asset. Then define _talkingFace, the 2-frame talk sheet (mouth closed and open), as a const so _say can use it as its default.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// The companion's talking face in the dialogue: its mouth opens and closes.
const _talkingFace = _Face(STRAWBERRY_TALK, amount: 2, stepTime: 0.15);

/// One of the companion's sprite sheets, played as a widget in the dialogue.
class _Face extends StatelessWidget {
  const _Face(
    this.path, {
    required this.amount,
    required this.stepTime,
    this.loop = true,
    this.onComplete,
  });

  /// Asset path of the sheet, relative to `assets/images/`.
  final String path;

  /// Number of 32x32 frames in the sheet.
  final int amount;

  /// Duration (in seconds) of each frame.
  final double stepTime;

  /// Whether the animation repeats; false plays it once and holds the last
  /// frame.
  final bool loop;

  /// Called when an animation that doesn't loop reaches its last frame.
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    return SpriteAnimationWidget.asset(
      path: path,
      data: SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
        loop: loop,
      ),
      onComplete: onComplete,
    );
  }
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add the _talkRadius and _hasTalked fields to Companion, override update with vision.seePlayer, write _talk and _say to show a TalkDialog, and add the _Face widget and _talkingFace below the class.',
      proTip:
          'TalkDialog moves to the next line on any key, so if you\'re still pressing Space as you reach the companion you can skip a line; try a bigger _talkRadius to start the talk earlier.',
    );
  }
}
