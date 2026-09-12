import 'package:bonfire_crash_course/core/gap_sizes.dart';
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
      objective: Text(
        'Define a custom character component that extends SimplePlayer and configure its visual spritesheet, idle animations, and hitbox in a Bonfire game.',
        style: textTheme.bodyMedium!.copyWith(color: Colors.white),
      ),
      concepts: Text(
        'Components are the fundamental building blocks in Bonfire. SimplePlayer provides the base physics, keyboard input handling, and direction logic; you customize assets, animations, and collision shapes.',
        style: textTheme.bodyMedium!.copyWith(color: Colors.white),
      ),
      example: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'In your main game file, extend SimplePlayer, provide the path to your sprite sheet, and configure the animation cycle and collision box.',
            style: textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
          GapSizes.smallGap,
          CodeSnippetCard(fileName: 'main.dart', code: snippet),
          GapSizes.smallGap,
          Row(
            children: [
              Spacer(),
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
      ),
      yourTurn: Text(
        'Open lib/game/game_view.dart in your Codespace. Create a new class that extends SimplePlayer, configure the assets/player.png spritesheet, set a collision box of (8, 8) and add the player component to the BonfireWidget, then verify the character appears and moves on the map.',
        style: textTheme.bodyMedium!.copyWith(color: Colors.white),
      ),
    );
  }

  @override
  String get snippet => '''BonfireWidget(
    map: WorldMapByTiled(
      WorldMapByTiledLoader(
        asset: 'maps/dungeon_map.tmx',
      ),
    ),
  );''';

  @override
  String get videoUrl =>
      'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4';
}
