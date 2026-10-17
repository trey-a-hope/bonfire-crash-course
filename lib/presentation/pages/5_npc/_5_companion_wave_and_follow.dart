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
          'Make Berry wave hello in the dialogue, then wave goodbye in the world and follow the hero along the ground: stopping beside them, waiting at walls or when the hero is out of sight, passing through the hero instead of bumping, and always drawn just behind them.',
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
          title: 'onBlockMovementListener',
          subtitle:
              'Bonfire asks this before a collision stops a component. Returning false for the Player lets the hero and Berry pass through each other, so a hero who turns around never shoves Berry along; tiles still block it.',
        ),
        Concept(
          title: 'priority (draw order)',
          subtitle:
              'Bonfire draws higher priorities on top, based on how low a component stands on screen. Berry overrides the priority getter to sit one under the hero, so the hero is always drawn in front, which suits a side-scroller where they share the same ground.',
        ),
        Concept(
          title: 'Two waves: portrait and playOnceOther',
          subtitle:
              'The game is paused while the dialogue is open, so the hello wave plays in the dialogue portrait (_WaveThenTalk). When it closes, animation.playOnceOther plays the in-world wave from the others map and returns a Future; following starts when it completes.',
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
              'Add the follow fields after _talkRadius: how close the companion walks up to the hero, how far it can see them, and whether it is following yet.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// How close (in pixels) the hero must be before the companion talks.
static const _talkRadius = 48.0;

/// How close (centre to centre, in pixels) the companion walks up to the
/// hero before stopping. Both are 32 wide, so this leaves a 4px gap.
///
/// It is less than [_talkRadius] on purpose, so the companion can stand
/// beside the hero without crowding them. Following never reopens the
/// dialogue: once the companion follows, it has had its one talk.
static const followDistance = 36.0;

/// How far (in pixels) the companion can see the hero while following.
/// If the hero gets farther than this, the companion stops and waits.
static const followRadius = 160.0;
...
bool _hasTalked = false;

/// True after the first conversation: from then on the companion follows
/// the hero around.
bool _isFollowing = false;
''',
        ),
        CodeStep(
          description:
              'In onLoad, after the hitbox, add collision.onBlockMovementListener so the hero and the companion pass through each other. Return false (let the movement through) only when the other component is the Player.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Runs once when the companion is added to the game.
@override
Future<void> onLoad() async {
  // The hitbox is the companion's solid shape: it stands on the ground
  // and stops at walls.
  add(RectangleHitbox(size: size));

  // The hero and the companion pass through each other instead of
  // bumping: otherwise a hero who turns around would shove the companion
  // along. Bonfire asks this before a collision stops either of them;
  // returning false lets the movement through. Tiles still block it, so it
  // still stands on the ground and stops at walls.
  collision.onBlockMovementListener((_, other) => other is! Player);
  return super.onLoad();
}
''',
        ),
        CodeStep(
          description:
              'Override the priority getter so the companion always sits one under the hero and the hero is drawn in front. hasGameRef guards the first frames, before the companion is in the game.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Draw order: Bonfire draws components with a higher priority on top,
/// based on how low they stand on screen. The companion takes one less
/// than the hero, so the hero is always drawn in front, even when they
/// stand on the same spot.
@override
int get priority {
  final hero = hasGameRef ? gameRef.player : null;
  if (hero == null) return super.priority;
  return hero.priority - 1;
}
''',
        ),
        CodeStep(
          description:
              'Update update: follow the hero once _isFollowing is true, before checking whether to talk.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Called every game tick: follows the hero (after the first talk) and
/// checks whether the hero is close enough to talk.
@override
void update(double dt) {
  if (_isFollowing) _follow();

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
              'Below the Companion class, write _WaveThenTalk: the face for the first line of dialogue. It plays the 6-frame wave sheet once with _Face (loop: false), then switches to _talkingFace, which is built hidden from the start so it shows up without a blank frame.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// The companion's face in the first line of dialogue: waves hello once,
/// then switches to [_talkingFace].
class _WaveThenTalk extends StatefulWidget {
  const _WaveThenTalk();

  @override
  State<_WaveThenTalk> createState() => _WaveThenTalkState();
}

class _WaveThenTalkState extends State<_WaveThenTalk> {
  /// True until the wave has played once.
  bool _isWaving = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Built (but hidden) from the start, so it has loaded by the time
        // the wave ends and shows up without a blank frame in between.
        Visibility.maintain(visible: !_isWaving, child: _talkingFace),
        if (_isWaving)
          _Face(
            STRAWBERRY_WAVE,
            amount: 6,
            stepTime: 0.12,
            // Play once and stop, instead of waving forever.
            loop: false,
            // The dialogue may close (and remove this widget) before the
            // wave ends.
            onComplete: () {
              if (mounted) setState(() => _isWaving = false);
            },
          ),
      ],
    );
  }
}
''',
        ),
        CodeStep(
          description:
              'Add the in-world wave: a _waveAnimation key with the other fields, and the wave sheet in the SimpleDirectionAnimation\'s others map after runLeft. loop: false plays it once.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
/// Key of the wave animation in the animation's `others` map.
static const _waveAnimation = 'wave';
...
animation: SimpleDirectionAnimation(
  ... // idleRight, idleLeft, runRight, runLeft
  // Played once when the dialogue closes, as a "let's go" wave
  // before following the hero (see [_talk]).
  others: {
    _waveAnimation: AnimationUtils.loadAnimation(
      STRAWBERRY_WAVE,
      amount: 6,
      stepTime: 0.12,
      loop: false,
    ),
  },
),
''',
        ),
        CodeStep(
          description:
              'Update _talk: stop the companion too, give the first line the _WaveThenTalk face, and in onClose resume the game, play the in-world wave with playOnceOther and start following when its Future completes.',
          fileName: DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: r'''
/// Pauses the game and opens the dialogue (only once). When it closes,
/// the companion waves and then follows the hero.
void _talk() {
  if (_hasTalked) return;
  _hasTalked = true;

  // Stop the hero, and the companion if it was following.
  gameRef.player?.onJoystickChangeDirectional(
    JoystickDirectionalEvent(directional: JoystickMoveDirectional.IDLE),
  );
  _stopWalking();

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
      // Wave once more, then follow the hero from now on. playOnceOther
      // returns a Future that completes when the wave ends (or right away
      // if there is no wave), so following always starts.
      final wave = animation?.playOnceOther(
        _waveAnimation,
        // Without this, the switch back to idle would cut the wave short.
        runToTheEnd: true,
      );
      (wave ?? Future.value()).then((_) => _isFollowing = true);
    },
  );
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add the FollowAction enum, follow fields, onBlockMovementListener and a priority override to companion.dart, write followAction, _follow, _stopWalking and the _WaveThenTalk widget, and update update and _talk so Berry waves and then follows.',
      proTip:
          'Jump the hero up onto a ledge after the talk: Berry can\'t jump, so canMove stops it at the wall below until you come back down. Run more than followRadius (160 px) away and it waits where it is, then picks up following again when you come back within range.',
    );
  }
}
