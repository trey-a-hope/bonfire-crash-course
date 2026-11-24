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
          codeMatch: 'PlatformPlayer',
          subtitle:
              'Bonfire\'s side-scroller player. It handles horizontal movement and jumping, and swaps animations based on what the hero is doing and which way it faces.',
        ),
        Concept(
          title: 'CharacterAsset',
          short: 'One value that picks every sprite for a character.',
          codeMatch: 'CharacterAsset',
          subtitle:
              'An enum in lib/core/constants/character_asset.dart that bundles every sprite sheet path for one character (wizard or shark). Switching characters is a one-word change.',
        ),
        Concept(
          title: 'SpriteAnimation',
          short: 'A sheet sliced into frames that play in order.',
          codeMatch: 'stepTime',
          subtitle:
              'A sprite sheet sliced into equal frames that play in order. stepTime is how long each frame stays on screen, so a bigger number plays slower.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Create a new class named Hero that extends PlatformPlayer to enable side-scroller movement and jumping.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''/// The playable hero character.
///
/// [PlatformPlayer] gives us side-scroller movement and jumping.
class HeroPlayer extends PlatformPlayer { ... }
''',
        ),
        CodeStep(
          description:
              'Define the Hero constructor, passing the initial spawn position and frame dimensions to the superclass.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
/// Creates the hero at [position] (in pixels from the map's top-left).
HeroPlayer(Vector2 position)
    : super(
        position: position,
        // Size on screen: one tile (TILE_SIZE, 32 pixels) square,
        // matching one 32x32 frame.
        size: Vector2.all(TILE_SIZE),
      );
''',
        ),
        CodeStep(
          description:
              'Pick which character sprite set the hero uses. The template ships the wizard and the shark; try both.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''static const _asset = CharacterAsset.wizard;
''',
        ),
        CodeStep(
          description:
              'Configure PlatformAnimations to assign sprite animations for running and idling in left and right directions.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
// Which animation to play for each state and direction.
animation: SpriteTools.buildAnimation(asset: _asset),
''',
        ),
        CodeStep(
          description:
              'Instantiate Hero with an initial position and pass it to the player property in BonfireWidget.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
@override
Widget build(BuildContext context) {
  return BonfireWidget(
    player: HeroPlayer(Vector2(100, 100)),
  );
}
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
