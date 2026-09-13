import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/lotties/_lotties.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/code_snippet_card.dart';
import 'package:bonfire_crash_course/presentation/widgets/course_video_player.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_outline.dart';
import 'package:flutter/material.dart';

class PlayerComponentPage extends StatelessWidget implements iPageOutline {
  const PlayerComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PageOutline(
      title: 'Creating the Player Component',
      lottie: const PlayerLottie(),
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
      steps: [
        Text(
          'In your main game file, extend SimplePlayer, provide the path to your sprite sheet, and configure the animation cycle and collision box.',
          style: textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        GapSizes.smallGap,
        const CodeSnippetCard(
          fileName: 'main.dart',
          code: '''BonfireWidget(
    map: WorldMapByTiled(
      WorldMapByTiledLoader(
        asset: 'maps/dungeon_map.tmx',
      ),
    ),
  );''',
        ),
        GapSizes.smallGap,
        Row(
          children: [
            const Spacer(),
            AdaptiveButton(
              type: AdaptiveButtonType.filled,
              onPressed: () {
                CourseVideoPlayer.showModal(
                  context,
                  videoUrl: videoUrl,
                  title: 'Course Lesson Video',
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded),
                  SizedBox(width: 8),
                  Text('Watch Video Lesson'),
                ],
              ),
            ),
          ],
        ),
      ],
      timeToCodeStatement: 'Approx. 10 minutes',
    );
  }

  @override
  String get videoUrl =>
      'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4';
}
