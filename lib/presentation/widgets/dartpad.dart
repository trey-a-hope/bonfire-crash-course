import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/course_video_player.dart';
import 'package:bonfire_crash_course/presentation/widgets/version_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dartpad/flutter_dartpad.dart';

const _horizontalPadding = 32.0;

class DartPadExerciseScreen extends StatelessWidget {
  // Replace with your GitHub Gist ID containing main.dart / test.dart / solution.dart
  final String gistId;

  const DartPadExerciseScreen({required this.gistId, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        GapSizes.xlGap,
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: _horizontalPadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Adding a player now nigga!',
                            style: textTheme.headlineSmall!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          AdaptiveButton(
                            type: AdaptiveButtonType.filled,
                            onPressed: () {
                              CourseVideoPlayer.showModal(
                                context,
                                videoUrl:
                                    'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
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

                      GapSizes.xsGap,
                      Divider(),
                      GapSizes.xsGap,
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Text(
                                'To spawn a playable character into your game world using the Bonfire RPG engine, extend the SimplePlayer class with sprite animations and assign it to the player property of the BonfireWidget.',
                                style: textTheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              GapSizes.mediumGap,
                              Text(
                                'Create your player component with positional coordinates, collision hitboxes, and directional sprites:',
                                style: textTheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              GapSizes.mediumGap,
                              Card(
                                child: ListTile(
                                  leading: Icon(Icons.warning),
                                  title: Text(
                                    'NOTE: This is where the first place goes.',
                                  ),
                                ),
                              ),
                              GapSizes.mediumGap,
                              Text(
                                'To spawn a playable character into your game world using the Bonfire RPG engine, extend the SimplePlayer class with sprite animations and assign it to the player property of the BonfireWidget.',
                                style: textTheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              GapSizes.mediumGap,
                              Text(
                                'Create your player component with positional coordinates, collision hitboxes, and directional sprites:',
                                style: textTheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              GapSizes.mediumGap,
                              Card(
                                child: ListTile(
                                  leading: Icon(Icons.warning),
                                  title: Text(
                                    'NOTE: This is where the first place goes.',
                                  ),
                                ),
                              ),
                              GapSizes.largeGap,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // GapSizes.largeGap,
                // Expanded(
                //   child: CourseVideoPlayer(
                //     videoUrl:
                //         'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
                //   ),
                // ),
              ],
            ),
          ),
        ),
        GapSizes.mediumGap,
        Flexible(
          flex: 2,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: _horizontalPadding,
            ),
            child: Dartpad(
              key: const Key('exercise_dartpad'),
              embeddingChoice: EmbeddingChoice.flutter,
              gistId: gistId,
              darkMode: true,
              split: 60, // Split ratio between editor and output (60% editor)
              runImmediately: false, // Wait for user to finish and hit Run
              onProgress: (val) => debugPrint('Dartpad progress: $val'),
            ),
          ),
        ),
        GapSizes.mediumGap,
        VersionLabel(),
        GapSizes.mediumGap,
      ],
    );
  }
}
