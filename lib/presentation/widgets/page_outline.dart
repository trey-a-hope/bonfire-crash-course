import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';

mixin iPageOutline {
  String get snippet;
  String get videoUrl;
}

class PageOutline extends StatelessWidget {
  final Widget objective;
  final Widget concepts;
  final Widget example;
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
      ],
    );
  }
}
