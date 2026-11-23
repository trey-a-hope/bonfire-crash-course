import '../../../core/modules/player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_HERO = 'lib/presentation/characters/hero.dart';

class ApplyCollisionToPlayerPage extends StatelessWidget {
  const ApplyCollisionToPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 3,
      title: 'Apply Collision to Player',
      outcome: 'The hero lands on the ground instead of falling through.',
      objective:
          'Apply collision to the player component in a Bonfire game by configuring its shape, size, and physics properties.',
      concepts: [
        Concept(
          title: 'RectangleHitbox',
          short: 'The hero\'s solid shape.',
          codeMatch: 'RectangleHitbox',
          subtitle:
              'Defines the collision area of the player component as a rectangle.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'By default, the player doesn’t have a shape for the physics engine to detect. Add a hitbox to give the hero volume.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
/// Runs once when the hero is added to the game.
@override
Future<void> onLoad() async {
  // The hitbox is the hero's solid shape.
  // Without it, the hero falls straight through the ground.
  add(RectangleHitbox(size: size));
  return super.onLoad();
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to override onLoad in hero.dart and add a RectangleHitbox the same size as the hero.',
      proTip:
          'While testing, set debugMode: true on BonfireWidget to outline every hitbox, so you can see exactly where the hero meets the ground.',
    );
  }
}
