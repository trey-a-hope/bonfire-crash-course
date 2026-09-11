import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_index_widget.dart';
import 'package:flutter/material.dart';

/// Interface defining lesson metadata requirements for course pages.
mixin iPageOutline {
  /// The source code snippet displayed for this lesson.
  String get snippet;

  /// The remote URL of the video walkthrough for this lesson.
  String get videoUrl;
}

/// A standardized layout structure for course lesson pages.
///
/// Displays the lesson's [objective], [concepts], [example], and [yourTurn]
/// sections, followed by bottom [PageIndexWidget] navigation controls.
class PageOutline extends StatelessWidget {
  /// 1–2 sentences explaining what mechanic is being built.
  final Widget objective;

  /// A brief explanation of the Bonfire APIs introduced in this section.
  final Widget concepts;

  /// Code snippets and video demonstrations showcasing the lesson concepts.
  final Widget example;

  /// Actionable checkpoint or coding exercise for the learner to verify.
  final Widget yourTurn;

  const PageOutline({
    super.key,
    required this.objective,
    required this.concepts,
    required this.example,
    required this.yourTurn,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        // Objective: 1–2 sentences explaining what mechanic they are building.
        Text(
          'Objective',
          style: textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
        GapSizes.xsGap,
        objective,
        GapSizes.largeGap,
        // Concepts: Brief explanation of the Bonfire APIs introduced (e.g., SimplePlayer, Direction).
        Text(
          'Concepts',
          style: textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
        GapSizes.xsGap,
        concepts,
        GapSizes.largeGap,
        // Example: What visual result or interaction to verify in their running app before moving to the next section.
        Text(
          'Example',
          style: textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
        GapSizes.xsGap,
        example,
        GapSizes.largeGap,
        // Checkpoint: What visual result or interaction to verify in their running app before moving to the next section.
        Text(
          'Your Turn',
          style: textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
        GapSizes.xsGap,
        yourTurn,
        GapSizes.largeGap,
        PageIndexWidget(),
      ],
    );
  }
}
