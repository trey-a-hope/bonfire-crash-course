import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/modules/_modules.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class ApplyCustomBackground extends StatelessWidget {
  const ApplyCustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CodingScaffold(
      module: MAP_MODULE,
      unitStep: 2,
      title: 'Apply a Custom Background',
      subtitle:
          'Load a parallax background with multiple scrolling layers to create a dynamic and immersive game environment.',
      objective: Text(
        'A common requirement in 2D games is having background elements—such as a sky or drifting clouds—that scroll continuously on their own, independent of the player\'s movement. In Bonfire, you can easily achieve this inside a GameBackground component by using loadParallaxComponent.',
        style: textTheme.bodyMedium!.copyWith(color: Colors.white),
      ),
      concepts: const [
        Concept(
          title: 'Parallax Background',
          subtitle:
              'A background component that uses loadParallaxComponent to create an auto-scrolling atmospheric background where layered images move continuously without depending on player or camera movement.',
        ),
      ],
      codeSteps: const [
        CodeStep(
          description:
              'Create a new class that extends the GameBackground class.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
// TODO
class ParallaxBackground extends GameBackground {
    @override
    // TODO
    Future<void> onLoad() async {
        await super.onLoad();
    }
}
''',
        ),
        CodeStep(
          description:
              'Define constant image paths relative to your assets directory to keep asset references organized and reusable.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
static const _skyUrl = 'background/sky.png';
static const _cloudsUrl = 'background/clouds.png';
static const _mountainsUrl = 'background/mountains.png';
static const _hillsUrl = 'background/hills.png';
''',
        ),
        CodeStep(
          description:
              'Use loadParallaxComponent to create an auto-scrolling atmospheric background where layered images move continuously without depending on player or camera movement. By configuring baseVelocity and velocityMultiplierDelta, you make foreground clouds drift faster than the distant sky to achieve a realistic sense of visual depth.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
// TODO
static const _skyUrl = 'background/sky.png';
static const _cloudsUrl = 'background/clouds.png';
static const _mountainsUrl = 'background/mountains.png';
static const _hillsUrl = 'background/hills.png';
''',
        ),

        CodeStep(
          description:
              'Use loadParallaxComponent to create an auto-scrolling atmospheric background where layered images move continuously without depending on player or camera movement.',
          fileName: DART_FILE_PARALLAX_BACKGROUND,
          codeSnippet: '''
// TODO
final skyAndClouds = await loadParallaxComponent(
    [
        ParallaxImageData(_skyUrl),
        ParallaxImageData(_cloudsUrl),
    ],
    // TODO
    baseVelocity: Vector2(10, 0),
    // TODO
    velocityMultiplierDelta: Vector2(1.5, 1),
);
''',
        ),
      ],
      timeToCodeStatement:
          'Now it\'s your turn to build the atmosphere! Head over to parallax_background.dart to create your ParallaxBackground class, assemble the layered scrolling components, and plug it into your BonfireWidget.',
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
    );
  }
}
