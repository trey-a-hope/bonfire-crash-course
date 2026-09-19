import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/lotties/i_lottie.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_list_tile.dart';
import 'package:bonfire_crash_course/presentation/widgets/course_video_player.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_index_widget.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

/// Interface defining lesson metadata requirements for course pages.
mixin iPageOutline {
  /// The remote URL of the video walkthrough for this lesson.
  String get videoUrl;
  Color get color;
}

/// A standardized layout structure for course lesson pages.
///
/// Displays the lesson's [objective], [concepts], [example], and [yourTurn]
/// sections, followed by bottom [PageIndexWidget] navigation controls.
class PageOutline extends SignalWidget {
  final String title;

  final ILottie lottie;

  /// 1–2 sentences explaining what mechanic is being built.
  final Widget objective;

  /// A brief explanation of the Bonfire APIs introduced in this section.
  final List<Concept> concepts;

  /// Code snippets and video demonstrations showcasing the lesson concepts.
  final List<CodeStep> codeSteps;

  /// Actionable checkpoint or coding exercise for the learner to verify.
  final String timeToCodeStatement;

  const PageOutline({
    super.key,
    required this.title,
    required this.lottie,
    required this.objective,
    required this.concepts,
    required this.codeSteps,
    required this.timeToCodeStatement,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: textTheme.headlineLarge!.copyWith(color: Colors.white),
            ),
            const Spacer(),
            AdaptiveButton(child: const Text('Follow Here'), onPressed: () {}),
          ],
        ),

        GapSizes.mediumGap,

        Expanded(
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: lottie),
                      // Objective: 1–2 sentences explaining what mechanic they are building.
                      Text(
                        'Objective',
                        style: textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      GapSizes.xsGap,
                      objective,
                      const Divider(
                        color: Colors.grey,
                        height: 64,
                        thickness: 1,
                      ),
                      // Concepts: Brief explanation of the Bonfire APIs introduced (e.g., SimplePlayer, Direction).
                      Text(
                        'Concepts',
                        style: textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      GapSizes.xsGap,
                      ...concepts.map(
                        (concept) => AdaptiveListTile(
                          icon: Icons.lightbulb,
                          title: concept.title,
                          subtitle: concept.subtitle,
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 64,
                        thickness: 1,
                      ),
                      // Example: What visual result or interaction to verify in their running app before moving to the next section.
                      Text(
                        'Time to Code',
                        style: textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      GapSizes.xsGap,
                      StepsWidget.code(codeSteps: codeSteps),
                    ],
                  ),
                ),
              ),
              GapSizes.xlGap,
              const Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    CourseVideoPlayer(
                      videoUrl:
                          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
                      title: 'Flight Tutorial',
                    ),
                    GapSizes.largeGap,
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
