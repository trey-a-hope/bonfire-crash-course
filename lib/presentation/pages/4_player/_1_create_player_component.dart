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
          'Define a Hero component that extends PlatformPlayer, pick a character sprite set, and give it idle and run animations in a Bonfire game.',

      concepts: [
        Concept(
          title: 'PlatformPlayer',
          subtitle:
              'Bonfire\'s side-scroller player. It handles horizontal movement and jumping, and swaps animations based on what the hero is doing and which way it faces.',
        ),
        Concept(
          title: 'CharacterAsset',
          subtitle:
              'An enum in lib/core/constants/character_asset.dart that bundles every sprite sheet path for one character (wizard or shark). Switching characters is a one-word change.',
        ),
        Concept(
          title: 'SpriteAnimation',
          subtitle:
              'A sprite sheet sliced into equal frames that play in order. stepTime is how long each frame stays on screen, so a bigger number plays slower.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Create a new class named Hero that extends PlatformPlayer to enable side-scroller movement and jumping.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''/// The playable hero character.
///
/// [PlatformPlayer] gives us side-scroller movement and jumping.
class Hero extends PlatformPlayer {
}
''',
        ),
        CodeStep(
          description:
              'Define the Hero constructor, passing the initial spawn position and frame dimensions to the superclass.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
/// Creates the hero at [position] (in pixels from the map's top-left).
Hero(Vector2 position)
    : super(
        position: position,
        // Size on screen; matches one 32x32 frame.
        size: Vector2.all(32),
      );
''',
        ),
        CodeStep(
          description:
              'Pick which character sprite set the hero uses. The template ships the wizard and the shark; try both.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''static const _asset = CharacterAsset.wizard;
''',
        ),
        CodeStep(
          description:
              'Create an AnimationUtils helper that turns a sprite sheet into a SpriteAnimation. Every animation in the course goes through it, and loop: false is used later for one-shot attacks.',
          fileName: DART_FILE_ANIMATION_UTILS,
          codeSnippet: '''
/// Utility helpers for loading sprite animations.
abstract class AnimationUtils {
  /// Turns a sprite sheet into a looping animation.
  ///
  /// - [path]: Asset path relative to `assets/images/`.
  /// - [amount]: Number of frames in the sheet (defaults to 4).
  /// - [stepTime]: Duration (in seconds) per frame.
  /// - [textureSize]: Frame dimension (defaults to 32x32).
  /// - [loop]: Whether the animation repeats (defaults to true). Use false for
  ///   one-shot animations such as attacks.
  static Future<SpriteAnimation> loadAnimation(
    String path, {
    int amount = 4,
    double stepTime = 0.1,
    Vector2? textureSize,
    bool loop = true,
  }) {
    return SpriteAnimation.load(
      path,
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: textureSize ?? Vector2.all(32),
        loop: loop,
      ),
    );
  }
}
''',
        ),
        CodeStep(
          description:
              'Configure PlatformAnimations to assign sprite animations for running and idling in left and right directions.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
// Which animation to play for each state and direction.
animation: PlatformAnimations(
  runLeft: AnimationUtils.loadAnimation(_asset.runLeft),
  runRight: AnimationUtils.loadAnimation(_asset.runRight),
  // Idle uses a larger stepTime so it plays slower than walking.
  idleLeft: AnimationUtils.loadAnimation(_asset.idleLeft, stepTime: 0.2),
  idleRight: AnimationUtils.loadAnimation(_asset.idleRight, stepTime: 0.2),
),   
''',
        ),
        CodeStep(
          description:
              'Instantiate Hero with an initial position and pass it to the player property in BonfireWidget.',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
@override
Widget build(BuildContext context) {
  return BonfireWidget(
    player: Hero(Vector2(100, 100)),
  );
}
''',
        ),
      ],
      timeToCodeStatement: 'Approx. 10 minutes',
    );
  }
}
