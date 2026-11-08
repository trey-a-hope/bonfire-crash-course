import 'npc_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_COMPANION =
    'lib/presentation/characters/companion.dart';

class CompanionCutscenePage extends StatelessWidget {
  const CompanionCutscenePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: NPC_MODULE,
      unitStep: 6,
      title: 'Berry\'s First-Meeting Cutscene',
      outcome: 'The camera pans to Berry for the talk, then back to the hero.',
      objective:
          'Turn the first conversation into a short cutscene with Bonfire\'s scene builder: the camera pans and zooms to Berry, the dialogue opens, and when it closes the camera pans back to the hero while Berry waves. The hero gets control back only once the camera is home.',
      concepts: [
        Concept(
          title: 'gameRef.startScene',
          short: 'Runs scene actions one after another.',
          codeMatch: 'startScene',
          subtitle:
              'Runs a list of scene actions one after another, each starting when the one before it finishes. While a scene runs, gameRef.sceneBuilderStatus.isRunning is true.',
        ),
        Concept(
          title: 'CameraSceneAction.target',
          short: 'Pans and zooms the camera to a component.',
          codeMatch: 'CameraSceneAction.target',
          subtitle:
              'Pans the camera to a component (and zooms, if you give a zoom) over a duration. It drops any fraction of a second, so use whole seconds: Duration(milliseconds: 1500) pans in 1 second.',
        ),
        Concept(
          title: 'AwaitSceneAction',
          short: 'Waits until the dialogue closes.',
          codeMatch: 'AwaitSceneAction',
          subtitle:
              'Pauses the scene until a Future completes. Berry\'s scene waits here until the dialogue has closed, then moves on to the pan back.',
        ),
        Concept(
          title: 'sceneBuilderStatus',
          short: 'Tells you a cutscene is running.',
          subtitle:
              'The hero already returns early from update while a scene runs (Module 4, Map Boundaries for Player), so it stands still and ignores input. Enemies can check it too, so they freeze during cutscenes.',
        ),
        Concept(
          title: 'Other scene actions',
          short: 'More actions for your own cutscenes.',
          subtitle:
              'DelaySceneAction waits for a duration. MoveToPositionSceneAction walks a component to a position, and MoveWhileSceneAction moves it while a condition holds. CallbackSceneAction runs a function. CameraSceneAction.position pans to a point instead of a component. Extend SceneAction to write your own, and call gameRef.stopScene() to end a running scene early.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add an import for dart:async at the top of companion.dart, for the Completer the dialogue uses. Then add two constants to the Companion class, above _talk: how much the camera zooms in on Berry, and how long each pan takes.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// How much closer the camera zooms in on the companion while it talks.
static const _talkZoom = 1.25;

/// How long the camera takes to pan to the companion, and back to the
/// hero afterwards.
///
/// Whole seconds only: [CameraSceneAction] drops any fraction of a second.
static const _panDuration = Duration(seconds: 1);
''',
        ),
        CodeStep(
          description:
              'Replace _talk with the cutscene. It still runs only once and stops the hero and Berry, then remembers the current zoom and starts a scene with three actions: pan to Berry, wait for the dialogue, and pan back to the hero.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Plays the first conversation as a short cutscene (only once): the
/// camera pans to the companion, the dialogue opens, and when it closes
/// the camera pans back to the hero. The companion waves on the way back,
/// then follows the hero.
void _talk() {
  if (_hasTalked) return;
  _hasTalked = true;

  final hero = gameRef.player;
  if (hero == null) return;

  // Stop the hero, and the companion if it was following.
  hero.onJoystickChangeDirectional(
    JoystickDirectionalEvent(directional: JoystickMoveDirectional.IDLE),
  );
  _stopWalking();

  // The zoom the game had before the cutscene, to go back to after it.
  final zoom = gameRef.camera.zoom;

  // A scene runs its actions one after another. While it runs the hero
  // ignores input and stands still (see Hero.update), so the player gets
  // control back only once the camera is back on the hero.
  gameRef.startScene([
    // Pan (and zoom in a little) to the companion.
    CameraSceneAction.target(
      this,
      zoom: zoom * _talkZoom,
      duration: _panDuration,
    ),
    // Talk, and wait here until the dialogue closes.
    AwaitSceneAction(wait: _showDialogue),
    // Pan back to the hero at the original zoom. The camera keeps
    // following the hero after this.
    CameraSceneAction.target(hero, zoom: zoom, duration: _panDuration),
  ]);
}
''',
        ),
        CodeStep(
          description:
              'Move the dialogue into _showDialogue, which AwaitSceneAction waits on. It is the dialogue code from the last lesson, with one change: a Completer. Its future is returned straight away, and completing it in onClose tells the scene the dialogue is done.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: r'''
/// Pauses the game and shows the dialogue. Completes once it has closed
/// and the game is running again; the companion starts its wave then.
Future<void> _showDialogue() {
  final closed = Completer<void>();

  // Freeze the game right away, before the dialogue opens. Opening it can
  // stall the app for a moment; if the game kept running, that stall would
  // become one huge physics step and a hero in mid-jump could fall
  // straight through the ground.
  gameRef.pauseEngine();

  TalkDialog.show(
    context,
    [
      // The first line waves hello in the dialogue itself, since the game
      // (and the companion in it) is frozen.
      _say('Oh, hi there! I\'m Berry.', face: const _WaveThenTalk()),
      _say('Watch your step, the hills around here are tricky.'),
      _say('Mind if I tag along?'),
    ],
    // Runs once the dialogue is gone from the screen.
    onClose: () {
      gameRef.resumeEngine();
      // Wave once more (while the camera pans back), then follow the hero
      // from now on. playOnceOther returns a Future that completes when
      // the wave ends (or right away if there is no wave), so following
      // always starts.
      final wave = animation?.playOnceOther(
        _waveAnimation,
        // Without this, the switch back to idle would cut the wave short.
        runToTheEnd: true,
      );
      (wave ?? Future.value()).then((_) => _isFollowing = true);
      closed.complete();
    },
  );
  return closed.future;
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to import dart:async, add _talkZoom and _panDuration to Companion, replace _talk with a gameRef.startScene cutscene, and move the dialogue into _showDialogue, which completes a Completer when the dialogue closes.',
      proTip:
          'Try a DelaySceneAction(const Duration(seconds: 1)) before the pan back, so the camera lingers on Berry for a moment after the dialogue closes. Keep the pans in whole seconds: CameraSceneAction ignores the fraction in Duration(milliseconds: 1500).',
    );
  }
}
