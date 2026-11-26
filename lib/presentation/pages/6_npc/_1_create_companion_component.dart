import '../../../core/modules/npc_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_GAME_SCREEN = 'lib/presentation/screens/game_screen.dart';
const _DART_FILE_CHARACTERS_COMPANION =
    'lib/presentation/characters/companion.dart';

class CreateCompanionComponentPage extends StatelessWidget {
  const CreateCompanionComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: NPC_MODULE,
      unitStep: 1,
      title: 'Creating the Companion Component',
      outcome:
          'A companion joins the world next to the hero (not visible yet).',
      objective:
          'Define a Companion component that extends SimpleAlly, give it a size, life and speed, and add it to the game world next to the hero.',
      concepts: [
        Concept(
          title: 'Ally',
          short: 'An NPC on your side, hurt only by enemies.',
          subtitle:
              'An NPC on the player\'s side. Bonfire\'s Ally is an Npc with the WithLife mixin, so it has health and only takes damage from enemies, never from the hero.',
        ),
        Concept(
          title: 'SimpleAlly',
          short: 'The Ally type with direction animations.',
          subtitle:
              'The Ally type with direction animations. Bonfire 4.0 has no PlatformAlly, so the companion starts from SimpleAlly and gets its platform behaviour from mixins in a later lesson.',
        ),
        Concept(
          title: 'components',
          short: 'BonfireWidget\'s list for everything but the player.',
          subtitle:
              'A BonfireWidget list for everything in the world that isn\'t the player, like allies, enemies and decorations.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add all imports at the top of companion.dart.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
// Bonfire's components, plus the shared constants like TILE_SIZE.
+ import 'package:bonfire/bonfire.dart';
+ import 'package:bonfire_crash_course_playground/core/constants/globals.dart';
''',
        ),
        CodeStep(
          description:
              'Create companion.dart and a class named Companion that extends SimpleAlly.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
+ /// A friendly NPC that stands on the map and talks to the hero.
+ ///
+ /// [SimpleAlly] is Bonfire's Ally: an NPC on the player's side.
+ class Companion extends SimpleAlly {
+ }
''',
        ),
        CodeStep(
          description:
              'Define the Companion constructor, passing the spawn position, the frame size, its life and its speed to the superclass.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
+ /// Creates the companion at [position] (in pixels from the map's top-left).
+ Companion(Vector2 position)
+     : super(
+         position: position,
+         // Size on screen; matches one 32x32 frame.
+         size: Vector2.all(TILE_SIZE),
+         life: 100,
+         // Same speed as the hero (Bonfire's default, 80), so it keeps up
+         // instead of falling behind and losing sight of them.
+         speed: 80,
+       );
''',
        ),
        CodeStep(
          description: 'Add all imports at the top of game_screen.dart.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
+ import 'package:bonfire_crash_course_playground/presentation/characters/companion.dart';
''',
        ),
        CodeStep(
          description:
              'Add a Companion to BonfireWidget\'s components list. Place it by map tile instead of by pixel: tile (24, 7) is the row just above the ground in map 01, on a flat stretch of open ground, and multiplying by TILE_SIZE (32) turns it into a world position, so the companion starts standing on the ground.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
return BonfireWidget(
  player: Hero(Vector2(100, 100)),
+   // Everything else in the world: the friendly companion, for now.
+   components: [
+     // Tile (24, 7): the row just above the ground (row 8) in map 01, so
+     // the companion is already standing when the map loads. Columns
+     // 23-29 are flat open ground there, so it has room to follow the hero.
+     Companion(Vector2(24, 7) * TILE_SIZE),
+   ],
  ...
);
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to create the Companion class in companion.dart with its constructor, and add a Companion to BonfireWidget\'s components list.',
      proTip:
          'The companion has no animation yet, so you won\'t see it in game; that\'s expected, and the next lesson gives it the strawberry sprites.',
    );
  }
}
