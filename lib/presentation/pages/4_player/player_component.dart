import 'package:bonfire_crash_course/core/modules.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class PlayerComponentPage extends StatelessWidget {
  const PlayerComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: Modules.PLAYER,
      unitStep: 1,
      title: 'Creating the Player Component',
      objective: Text(
        'Define a custom character component that extends SimplePlayer and configure its visual spritesheet, idle animations, and hitbox in a Bonfire game.',
        style: textTheme.bodyMedium!.copyWith(color: Colors.white),
      ),
      concepts: const [
        Concept(
          title: 'Player Component',
          subtitle:
              'A custom character component that extends SimplePlayer and configures its visual spritesheet, idle animations, and hitbox in a Bonfire game.',
        ),
      ],
      codeSteps: const [
        CodeStep(
          description:
              'In your main game file, extend SimplePlayer, provide the path to your sprite sheet, and configure the animation cycle and collision box.',
          fileName: 'main.dart',
          codeSnippet: '''BonfireWidget(
    map: WorldMapByTiled(
      WorldMapByTiledLoader(
        asset: 'maps/dungeon_map.tmx',
      ),
    ),
  );''',
        ),
      ],
      timeToCodeStatement: 'Approx. 10 minutes',
    );
  }
}
