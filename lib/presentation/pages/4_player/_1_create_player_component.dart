import '../../../core/modules/player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_GAME_SCREEN = 'lib/presentation/screens/game_screen.dart';
const _DART_FILE_CHARACTERS_HERO = 'lib/presentation/characters/hero.dart';

/// Player lesson 1, "Creating the Player Component": creates the HeroPlayer
/// class in hero.dart and passes it to BonfireWidget's player in
/// game_screen.dart. Routed at `/player/player-component` in
/// `lib/core/pane_config.dart`.
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
      outcome: 'A wizard hero stands on the map, idle or running.',
      objective:
          'Define a Hero component that extends PlatformPlayer, pick a character sprite set, and give it idle and run animations in a Bonfire game.',

      concepts: [
        Concept(
          title: 'PlatformPlayer',
          short: 'Bonfire\'s side-scroller player: walks, jumps and animates.',
          subtitle:
              'Bonfire\'s side-scroller player. It handles horizontal movement and jumping, and swaps animations based on what the hero is doing and which way it faces.',
        ),
        Concept(
          title: 'CharacterAsset',
          short: 'One value that picks every sprite for a character.',
          subtitle:
              'An enum in lib/core/constants/character_asset.dart that bundles every sprite sheet path for one character (wizard or shark). Switching characters is a one-word change.',
        ),
        Concept(
          title: 'SpriteAnimation',
          short: 'A sheet sliced into frames that play in order.',
          subtitle:
              'A sprite sheet sliced into equal frames that play in order. stepTime is how long each frame stays on screen, so a bigger number plays slower.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add all imports at the top of hero.dart.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
+ import 'package:bonfire/bonfire.dart';
+ import 'package:bonfire_crash_course_playground/core/constants/character_asset.dart';
+ import 'package:bonfire_crash_course_playground/core/constants/globals.dart';
+ import 'package:bonfire_crash_course_playground/core/utils/sprite_tools.dart';
''',
        ),
        CodeStep(
          description: 'Add all imports at the top of game_screen.dart.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
+ import 'package:bonfire_crash_course_playground/presentation/characters/hero.dart';
''',
        ),
        CodeStep(
          description: 'Create a HeroPlayer class that extends PlatformPlayer.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
+ class HeroPlayer extends PlatformPlayer { ... }
''',
        ),
        CodeStep(
          description:
              'Add the constructor. It sets the spawn position and a one-tile size.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer {
+   HeroPlayer(Vector2 position)
+       : super(position: position, size: Vector2.all(TILE_SIZE));
}
''',
        ),
        CodeStep(
          description:
              'Pick the character sprite set. Try CharacterAsset.shark too.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer {
+   static const _asset = CharacterAsset.wizard;
  ...
}
''',
        ),
        CodeStep(
          description: 'Add the idle and run animations with SpriteTools.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
HeroPlayer(Vector2 position)
    : super(
        position: position,
        size: Vector2.all(TILE_SIZE),
+       animation: SpriteTools.buildAnimation(asset: _asset),
      );
''',
        ),
        CodeStep(
          description:
              'Pass a HeroPlayer to the player property in BonfireWidget.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
return BonfireWidget(
+   player: HeroPlayer(Vector2(100, 100)),
  ...
);
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to create the Hero class in hero.dart with its constructor and idle and run animations, write the AnimationUtils helper, and pass a Hero to BonfireWidget\'s player.',
      proTip:
          'To try a different character, change CharacterAsset.wizard to CharacterAsset.shark and save; every sprite path comes from that one value, so nothing else has to change.',
    );
  }
}
