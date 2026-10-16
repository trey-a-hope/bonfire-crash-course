import 'package:bonfire_crash_course/core/constants.dart';

import 'npc_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

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
      objective:
          'Make the companion talk when the hero comes close: watch for the hero with vision.seePlayer, pause the game, and show a TalkDialog that only reopens after the hero leaves and comes back.',
      concepts: [
        Concept(
          title: 'vision.seePlayer',
          subtitle:
              'Checks every tick whether the hero is within radiusVision pixels. observed runs while the hero is in range and notObserved runs while they\'re out of it.',
        ),
        Concept(
          title: 'TalkDialog and Say',
          subtitle:
              'Bonfire\'s built-in dialogue box. TalkDialog.show takes a list of Say lines, types each one out, and moves on when the player presses a key or taps.',
        ),
        Concept(
          title: 'pauseEngine and resumeEngine',
          subtitle:
              'Freeze and restart the game loop. Pausing while the dialogue is open stops the hero from walking off mid-conversation.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the fields the dialogue needs at the top of the Companion class: how close the hero must be, and whether the companion has already talked.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// How close (in pixels) the hero must be before the companion talks.
static const _talkRadius = 48.0;

/// True once the companion has talked, so the dialogue doesn't reopen
/// until the hero walks away and comes back.
bool _hasTalked = false;
''',
        ),
        CodeStep(
          description:
              'Override update and check for the hero with vision.seePlayer. When the hero leaves, reset _hasTalked so the companion can talk again.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Called every game tick to check whether the hero is close.
@override
void update(double dt) {
  vision.seePlayer(
    radiusVision: _talkRadius,
    observed: (_) => _talk(),
    // Once the hero walks out of range, the companion can talk again.
    notObserved: () => _hasTalked = false,
  );
  super.update(dt);
}
''',
        ),
        CodeStep(
          description:
              'Write _talk: stop the hero, pause the game, and show the dialogue. onClose resumes the game when the last line is done.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: r'''
/// Opens the dialogue once per visit and pauses the game while it's open.
void _talk() {
  if (_hasTalked) return;
  _hasTalked = true;

  // Stop the hero and freeze the game so nobody walks off mid-conversation.
  gameRef.player?.onJoystickChangeDirectional(
    JoystickDirectionalEvent(directional: JoystickMoveDirectional.IDLE),
  );
  gameRef.pauseEngine();

  TalkDialog.show(
    context,
    [
      _say('Oh, hi there! I\'m Berry.'),
      _say('Watch your step, the hills around here are tricky.'),
      _say('Come back and visit any time!'),
    ],
    onClose: gameRef.resumeEngine,
  );
}
''',
        ),
        CodeStep(
          description:
              'Write _say, which builds one line of dialogue with the strawberry\'s talking face beside it. The talk sheet has 2 frames (mouth closed and open). Add an import for package:flutter/material.dart at the top of companion.dart for TextSpan and SizedBox.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// One line of dialogue, with the companion's talking face beside it.
Say _say(String text) {
  return Say(
    text: [TextSpan(text: text)],
    person: SizedBox.square(
      dimension: 96,
      child: AnimationUtils.loadAnimation(
        STRAWBERRY_TALK,
        amount: 2,
        stepTime: 0.15,
      ).asWidget(),
    ),
  );
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add the _talkRadius and _hasTalked fields to Companion, override update with vision.seePlayer, and write _talk and _say to show a TalkDialog.',
      proTip:
          'TalkDialog moves to the next line on any key, so if you\'re still pressing Space as you reach the companion you can skip a line; try a bigger _talkRadius to start the talk earlier.',
    );
  }
}
