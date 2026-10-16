import 'package:bonfire_crash_course/core/constants.dart';

import 'npc_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class CompanionWaveAndFollowPage extends StatelessWidget {
  const CompanionWaveAndFollowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: NPC_MODULE,
      unitStep: 5,
      title: 'Make Berry Wave and Follow the Hero',
      objective:
          'Make Berry wave hello once when the dialogue opens, then follow the hero along the ground after the talk, stopping beside them and waiting when a wall is in the way or the hero is out of sight.',
      concepts: [
        Concept(
          title: 'FollowAction and followAction',
          subtitle:
              'An enum of what the companion does each tick (stop, lost, left, right) and a static function that picks one from the distance to the hero and whether the way is clear. It reads no game state, so a plain unit test can check it.',
        ),
        Concept(
          title: 'canMove, moveLeft and moveRight',
          subtitle:
              'canMove checks for a wall or step before walking. moveLeft and moveRight only set the horizontal speed, so gravity keeps pulling the companion down and it walks off ledges instead of floating.',
        ),
        Concept(
          title: 'others and playOnceOther',
          subtitle:
              'SimpleDirectionAnimation\'s others map holds extra animations by key, like the 6-frame wave. animation.playOnceOther plays one of them once, then goes back to idle or walk; runToTheEnd: true stops the switch back from cutting it short.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the FollowAction enum above the Companion class, and update the class comment to say what the companion now does.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// What the companion does this tick while following the hero.
enum FollowAction {
  /// Close enough, or blocked by a wall or step: stand still.
  stop,

  /// The hero is out of sight: stand still and wait for them to come back.
  lost,

  /// Walk left, towards the hero.
  left,

  /// Walk right, towards the hero.
  right,
}

/// A friendly NPC that talks to the hero, waves hello, and then follows
/// them around.
///
/// [SimpleAlly] is Bonfire's Ally: an NPC on the player's side. Bonfire 4.0
/// has no `PlatformAlly`, so [WithCollision] and [WithForces] give it the
/// same platform behaviour the hero gets from [PlatformPlayer].
class Companion extends SimpleAlly with WithCollision, WithForces { ... }
''',
        ),
        CodeStep(
          description:
              'Add the fields for following and waving below _talkRadius: how close the companion walks up to the hero, how far it can see them, and two flags for the dialogue and following. Replace the comment on _hasTalked too, since the talk now only happens once.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// How close (in pixels) the hero must be before the companion talks.
static const _talkRadius = 48.0;

/// How close (centre to centre, in pixels) the companion walks up to the
/// hero before stopping. Both are 32 wide, so this leaves a 4px gap and
/// the companion never pushes into the hero.
///
/// It is less than [_talkRadius] on purpose, so the companion can stand
/// beside the hero without crowding them. Following never reopens the
/// dialogue: once the companion follows, it has had its one talk.
static const followDistance = 36.0;

/// How far (in pixels) the companion can see the hero while following.
/// If the hero gets farther than this, the companion stops and waits.
static const followRadius = 160.0;

/// True once the companion has talked. Before the first talk is over, the
/// hero walking out of range resets it; after that the companion follows
/// and the dialogue never opens again.
bool _hasTalked = false;

/// True while the dialogue is on screen.
bool _isDialogueOpen = false;

/// True after the first conversation: from then on the companion follows
/// the hero around.
bool _isFollowing = false;
''',
        ),
        CodeStep(
          description:
              'Update update: follow the hero while following and no dialogue is open, and only reset _hasTalked when the hero leaves before the first talk is over.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Called every game tick: follows the hero (after the first talk) and
/// checks whether the hero is close enough to talk.
@override
void update(double dt) {
  if (_isFollowing && !_isDialogueOpen) _follow();

  vision.seePlayer(
    radiusVision: _talkRadius,
    observed: (_) => _talk(),
    // If the hero walks out of range before the talk is over, the
    // companion can talk again. Once following, it never resets.
    notObserved: () {
      if (!_isFollowing) _hasTalked = false;
    },
  );
  super.update(dt);
}
''',
        ),
        CodeStep(
          description:
              'Write the static followAction function, which decides what to do from three plain values: how far across the hero is, how far away they are, and whether the way is clear.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Decides what the companion does this tick while following.
///
/// [dx] is the hero's centre minus the companion's, along x (positive
/// means the hero is to the right). [distance] is the straight-line
/// distance between their centres. [canMove] says whether the companion
/// can step towards the hero (no wall or step in the way).
///
/// Pure function with no game state, so it is easy to unit test.
static FollowAction followAction({
  required double dx,
  required double distance,
  required bool canMove,
}) {
  // Hero out of sight: wait here until they come back.
  if (distance > followRadius) return FollowAction.lost;
  // Close enough: stand beside the hero.
  if (dx.abs() <= followDistance) return FollowAction.stop;
  // A wall or step it can't climb: wait instead of walking into it.
  if (!canMove) return FollowAction.stop;
  return dx > 0 ? FollowAction.right : FollowAction.left;
}
''',
        ),
        CodeStep(
          description:
              'Write _follow, which measures the hero from the hitbox centres, asks followAction what to do and walks left, right or stops. Add _stopWalking, which clears only the horizontal speed so a fall carries on.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Walks along the ground towards the hero and stops a short way off.
///
/// Only the horizontal speed is set; the vertical speed is left alone so
/// gravity keeps the companion on the ground (it walks off ledges and
/// lands instead of floating). It doesn't jump, so if the hero is up on a
/// ledge it waits at the wall below until they come back down.
void _follow() {
  final hero = gameRef.player;
  if (hero == null) return;

  final heroCenter = hero.rectCollision.center;
  final myCenter = rectCollision.center;
  final dx = heroCenter.dx - myCenter.dx;

  final action = followAction(
    dx: dx,
    distance: (heroCenter - myCenter).distance,
    // The hero's own hitbox is ignored; the distance check handles it.
    canMove: canMove(
      dx > 0 ? Direction.right : Direction.left,
      ignoreHitboxes: hero.shapeHitboxes,
    ),
  );

  // None of these touch the vertical speed, so gravity still applies.
  switch (action) {
    case FollowAction.stop:
    case FollowAction.lost:
      _stopWalking();
    case FollowAction.left:
      moveLeft();
    case FollowAction.right:
      moveRight();
  }
}

/// Stops walking sideways without cancelling a fall.
void _stopWalking() {
  if (velocity.x != 0) velocity = velocity.copyWith(x: 0);
}
''',
        ),
        CodeStep(
          description:
              'Update _talk: mark the dialogue open, stop the companion too, and start following when the dialogue closes. Remove the old gameRef.pauseEngine() call; the next step pauses the game after the wave instead.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: r'''
/// Waves hello and opens the dialogue (only once), then pauses the game
/// when the wave ends.
void _talk() {
  if (_hasTalked) return;
  _hasTalked = true;
  _isDialogueOpen = true;

  // Stop the hero, and the companion if it was following.
  gameRef.player?.onJoystickChangeDirectional(
    JoystickDirectionalEvent(directional: JoystickMoveDirectional.IDLE),
  );
  _stopWalking();

  ... // wave hello, then pause the game (next step)

  TalkDialog.show(
    context,
    [
      _say('Oh, hi there! I\'m Berry.'),
      _say('Watch your step, the hills around here are tricky.'),
      _say('Mind if I tag along?'),
    ],
    onClose: () {
      _isDialogueOpen = false;
      // From now on, follow the hero.
      _isFollowing = true;
      gameRef.resumeEngine();
    },
  );
}
''',
        ),
        CodeStep(
          description:
              'Make Berry wave hello. Add the _waveAnimation key with the other fields, add the 6-frame wave to the SimpleDirectionAnimation after runLeft in an others map (loop: false plays it once), and play it in _talk with playOnceOther, pausing the game when it ends.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Key of the wave animation in the animation's `others` map.
static const _waveAnimation = 'wave';
...
animation: SimpleDirectionAnimation(
  ... // idleRight, idleLeft, runRight, runLeft
  // Played once when the dialogue opens (see [_talk]).
  others: {
    _waveAnimation: AnimationUtils.loadAnimation(
      STRAWBERRY_WAVE,
      amount: 6,
      stepTime: 0.12,
      loop: false,
    ),
  },
),
...
void _talk() {
  ... // _hasTalked, _isDialogueOpen, stop the hero and _stopWalking()

  // Wave hello once, then go back to idle. The game keeps running until
  // the wave ends so it actually animates; the dialogue has keyboard
  // focus, so the hero can't wander off meanwhile. Then freeze the game.
  animation?.playOnceOther(
    _waveAnimation,
    // Without this, the switch back to idle would cut the wave short.
    runToTheEnd: true,
    onFinish: () {
      // Skip the pause if the player already closed the dialogue.
      if (_isDialogueOpen) gameRef.pauseEngine();
    },
  );

  ... // TalkDialog.show
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add the FollowAction enum and follow fields to companion.dart, write followAction, _follow and _stopWalking, update update and _talk, and play a wave from the animation\'s others map with playOnceOther.',
      proTip:
          'Jump the hero up onto a ledge after the talk: Berry can\'t jump, so canMove stops it at the wall below until you come back down. Run more than followRadius (160 px) away and it waits where it is.',
    );
  }
}
